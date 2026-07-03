import SwiftData
import XCTest
@testable import NomidaiTracker

@MainActor
final class WidgetSnapshotTests: XCTestCase {
    private func makeContainer() throws -> ModelContainer {
        try AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    }

    private func makeUserDefaults() throws -> UserDefaults {
        let suiteName = "WidgetSnapshotTests.\(UUID().uuidString)"
        let userDefaults = try XCTUnwrap(UserDefaults(suiteName: suiteName))
        userDefaults.removePersistentDomain(forName: suiteName)
        return userDefaults
    }

    func testStoreSavesAndLoadsSnapshot() throws {
        let userDefaults = try makeUserDefaults()
        let store = WidgetSnapshotStore(userDefaults: userDefaults)
        let updatedAt = Date(timeIntervalSince1970: 1_234_567)
        let snapshot = WidgetSnapshot(
            totalAmountYen: 2_400,
            remainingBudgetYen: 3_100,
            dryDayCount: 4,
            wealthLevelRawValue: WealthLevel.normal.rawValue,
            updatedAt: updatedAt,
            isMediumWidgetUnlocked: true
        )

        try store.save(snapshot)

        XCTAssertEqual(store.load(), snapshot)
    }

    func testBuilderCreatesRequiredFieldsWithDefaultMediumLocked() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try XCTUnwrap(try presetRepository.fetchActivePresets().first)
        let now = Date(timeIntervalSince1970: 1_725_177_600)
        _ = try DrinkEntryRepository(context: context).createEntry(
            from: preset,
            quantity: 2,
            amountYen: 500,
            occurredAt: now
        )
        let settings = try SettingsRepository(context: context).fetchOrCreateSettings(now: now)
        try SettingsRepository(context: context).setMonthlyBudgetYen(2_000, for: settings, updatedAt: now)

        let snapshot = try WidgetSnapshotBuilder(context: context).build(now: now)

        XCTAssertEqual(snapshot.totalAmountYen, 500)
        XCTAssertEqual(snapshot.remainingBudgetYen, 1_500)
        XCTAssertEqual(snapshot.dryDayCount, 0)
        XCTAssertFalse(snapshot.wealthLevelRawValue.isEmpty)
        XCTAssertEqual(snapshot.updatedAt, now)
        XCTAssertFalse(snapshot.isMediumWidgetUnlocked)
    }

    func testBuilderKeepsMediumUnlockedFlagWhenProvided() throws {
        let container = try makeContainer()
        let context = container.mainContext
        _ = try SettingsRepository(context: context).fetchOrCreateSettings()

        let snapshot = try WidgetSnapshotBuilder(context: context).build(
            now: Date(timeIntervalSince1970: 1_725_177_600),
            isMediumWidgetUnlocked: true
        )

        XCTAssertTrue(snapshot.isMediumWidgetUnlocked)
    }

    func testRefresherSavesSnapshotAndReloadsTimelines() throws {
        let container = try makeContainer()
        let context = container.mainContext
        _ = try SettingsRepository(context: context).fetchOrCreateSettings()
        let userDefaults = try makeUserDefaults()
        let store = WidgetSnapshotStore(userDefaults: userDefaults)
        var reloadCount = 0
        let refresher = WidgetSnapshotRefresher(
            context: context,
            store: store,
            reloadTimelines: { reloadCount += 1 }
        )

        try refresher.refresh(now: Date(timeIntervalSince1970: 1_725_177_600))

        XCTAssertNotNil(store.load())
        XCTAssertEqual(reloadCount, 1)
    }
}
