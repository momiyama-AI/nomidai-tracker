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
