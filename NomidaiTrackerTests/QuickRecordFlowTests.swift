import SwiftData
import XCTest
@testable import NomidaiTracker

@MainActor
final class QuickRecordFlowTests: XCTestCase {
    private func makeContainer() throws -> ModelContainer {
        try AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    }

    func testCreateEntryFromPresetSnapshotsPresetData() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets().first { $0.name == "缶ビール350" }!

        let entryRepository = DrinkEntryRepository(context: context)
        let entry = try entryRepository.createEntry(from: preset, quantity: 2, amountYen: 440)

        XCTAssertEqual(entry.presetNameSnapshot, "缶ビール350")
        XCTAssertEqual(entry.categoryRawValue, preset.categoryRawValue)
        XCTAssertEqual(entry.locationRawValue, preset.locationRawValue)
        XCTAssertEqual(entry.volumeML, preset.volumeML)
        XCTAssertEqual(entry.abvTenthsPercent, preset.abvTenthsPercent)
        XCTAssertEqual(entry.quantity, 2)
        XCTAssertEqual(entry.amountYen, 440)
    }

    func testQuantityTwoOrMoreProducesExpectedAmountAndPureAlcohol() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets().first { $0.name == "缶ビール350" }!

        let entryRepository = DrinkEntryRepository(context: context)
        let entry = try entryRepository.createEntry(from: preset, quantity: 3, amountYen: 660)

        XCTAssertEqual(entry.amountYen, 660)
        XCTAssertEqual(
            entry.pureAlcoholTenthsGram,
            AlcoholCalculator.pureAlcoholTenthsGram(volumeML: preset.volumeML * 3, abvTenthsPercent: preset.abvTenthsPercent)
        )
    }

    func testOutsideEntryHasZeroPureAlcohol() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets().first { $0.name == "外飲み" }!

        let entryRepository = DrinkEntryRepository(context: context)
        let entry = try entryRepository.createEntry(from: preset, quantity: 1, amountYen: 3_500)

        XCTAssertEqual(entry.volumeML, 0)
        XCTAssertEqual(entry.abvTenthsPercent, 0)
        XCTAssertEqual(entry.pureAlcoholTenthsGram, 0)
        XCTAssertEqual(entry.amountYen, 3_500)
    }

    func testIncrementUsageReordersPresetsByUsageThenRecency() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let wineGlass = try presetRepository.fetchActivePresets().first { $0.name == "ワイングラス" }!

        try presetRepository.incrementUsage(for: wineGlass, usedAt: .now)
        try presetRepository.incrementUsage(for: wineGlass, usedAt: .now)

        let reordered = try presetRepository.fetchActivePresets()
        XCTAssertEqual(reordered.first?.name, "ワイングラス")
        XCTAssertEqual(wineGlass.usageCount, 2)
        XCTAssertNotNil(wineGlass.lastUsedAt)
    }

    func testDeleteEntryRemovesFromDaySummaryAndWidgetSnapshot() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets().first { $0.name == "缶ビール350" }!
        let now = Date()

        let entryRepository = DrinkEntryRepository(context: context)
        let entry = try entryRepository.createEntry(from: preset, amountYen: 220, occurredAt: now)
        XCTAssertEqual(try entryRepository.fetchEntries(on: now).count, 1)
        XCTAssertEqual(try WidgetSnapshotBuilder(context: context).build(now: now).totalAmountYen, 220)

        try entryRepository.delete(entry)

        XCTAssertTrue(try entryRepository.fetchEntries(on: now).isEmpty)
        XCTAssertEqual(try SummaryRepository(context: context).monthlySummary(containing: now).totalAmountYen, 0)
        XCTAssertEqual(try WidgetSnapshotBuilder(context: context).build(now: now).totalAmountYen, 0)
    }

    func testUpdateEntryRefreshesSummaryInputs() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try XCTUnwrap(presetRepository.fetchActivePresets().first { $0.name == "缶ビール350" })
        let now = Date()

        let entryRepository = DrinkEntryRepository(context: context)
        let entry = try entryRepository.createEntry(from: preset, quantity: 1, amountYen: 220, occurredAt: now)
        try entryRepository.update(entry, quantity: 2, amountYen: 500)

        let summary = try SummaryRepository(context: context).monthlySummary(containing: now)
        let widgetSnapshot = try WidgetSnapshotBuilder(context: context).build(now: now)

        XCTAssertEqual(entry.quantity, 2)
        XCTAssertEqual(entry.amountYen, 500)
        XCTAssertEqual(entry.pureAlcoholTenthsGram, 280)
        XCTAssertEqual(summary.totalAmountYen, 500)
        XCTAssertEqual(widgetSnapshot.totalAmountYen, 500)
    }

    func testUpdateEntryDateMovesBetweenDayFetches() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try XCTUnwrap(presetRepository.fetchActivePresets().first { $0.name == "缶ビール350" })
        let calendar = Calendar.current
        let originalDate = try XCTUnwrap(calendar.date(from: DateComponents(year: 2026, month: 7, day: 3, hour: 20)))
        let movedDate = try XCTUnwrap(calendar.date(byAdding: .day, value: 1, to: originalDate))

        let entryRepository = DrinkEntryRepository(context: context)
        let entry = try entryRepository.createEntry(from: preset, quantity: 1, amountYen: 220, occurredAt: originalDate)
        try entryRepository.update(entry, occurredAt: movedDate)

        XCTAssertTrue(try entryRepository.fetchEntries(on: originalDate).isEmpty)
        XCTAssertEqual(try entryRepository.fetchEntries(on: movedDate).map(\.id), [entry.id])
    }
}

final class QuickRecordInputValidatorTests: XCTestCase {
    func testParseAmountYenExtractsDigitsOnly() {
        XCTAssertEqual(QuickRecordInputValidator.parseAmountYen("220"), 220)
        XCTAssertEqual(QuickRecordInputValidator.parseAmountYen("1,000"), 1_000)
    }

    func testParseAmountYenReturnsNilForEmptyOrNonNumeric() {
        XCTAssertNil(QuickRecordInputValidator.parseAmountYen(""))
        XCTAssertNil(QuickRecordInputValidator.parseAmountYen("円"))
    }

    func testClampedAmountYenNeverGoesNegative() {
        XCTAssertEqual(QuickRecordInputValidator.clampedAmountYen(-10), 0)
        XCTAssertEqual(QuickRecordInputValidator.clampedAmountYen(0), 0)
        XCTAssertEqual(QuickRecordInputValidator.clampedAmountYen(500), 500)
    }

    func testClampedQuantityIsAtLeastOne() {
        XCTAssertEqual(QuickRecordInputValidator.clampedQuantity(0), 1)
        XCTAssertEqual(QuickRecordInputValidator.clampedQuantity(-3), 1)
        XCTAssertEqual(QuickRecordInputValidator.clampedQuantity(5), 5)
    }
}
