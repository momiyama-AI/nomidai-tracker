import SwiftData
import XCTest
@testable import NomidaiTracker

@MainActor
final class SettingsAndPresetEditTests: XCTestCase {
    private func makeContainer() throws -> ModelContainer {
        try AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    }

    func testUpdateBaselineMonthlyYenPersists() throws {
        let container = try makeContainer()
        let repository = SettingsRepository(context: container.mainContext)
        let settings = try repository.fetchOrCreateSettings()

        try repository.setBaselineMonthlyYen(6_000, for: settings)

        XCTAssertEqual(settings.baselineMonthlyYen, 6_000)
    }

    func testSetAndClearMonthlyBudgetYen() throws {
        let container = try makeContainer()
        let repository = SettingsRepository(context: container.mainContext)
        let settings = try repository.fetchOrCreateSettings()

        try repository.setMonthlyBudgetYen(15_000, for: settings)
        XCTAssertEqual(settings.monthlyBudgetYen, 15_000)

        try repository.setMonthlyBudgetYen(nil, for: settings)
        XCTAssertNil(settings.monthlyBudgetYen)
    }

    func testUpdatePresetSavesPriceVolumeAndAbv() throws {
        let container = try makeContainer()
        let presetRepository = DrinkPresetRepository(context: container.mainContext)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets().first { $0.name == "缶ビール350" }!

        try presetRepository.updatePreset(preset, defaultPriceYen: 250, volumeML: 350, abvTenthsPercent: 55)

        XCTAssertEqual(preset.defaultPriceYen, 250)
        XCTAssertEqual(preset.volumeML, 350)
        XCTAssertEqual(preset.abvTenthsPercent, 55)
    }

    func testUpdatePresetKeepsOutsidePresetUsable() throws {
        let container = try makeContainer()
        let presetRepository = DrinkPresetRepository(context: container.mainContext)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let outsidePreset = try presetRepository.fetchActivePresets().first { $0.name == "外飲み" }!

        try presetRepository.updatePreset(outsidePreset, defaultPriceYen: 3_500, volumeML: 0, abvTenthsPercent: 0)

        let entry = try DrinkEntryRepository(context: container.mainContext).createEntry(from: outsidePreset, quantity: 1)

        XCTAssertEqual(outsidePreset.defaultPriceYen, 3_500)
        XCTAssertEqual(entry.amountYen, 3_500)
        XCTAssertEqual(entry.pureAlcoholTenthsGram, 0)
    }

    func testCreateCustomPresetsAllowsThreeFreeSlots() throws {
        let container = try makeContainer()
        let presetRepository = DrinkPresetRepository(context: container.mainContext)

        for index in 1...DrinkPresetRepository.freeCustomPresetLimit {
            _ = try presetRepository.createCustomPreset(
                name: "カスタム\(index)",
                category: .custom,
                location: .home,
                defaultPriceYen: 200,
                volumeML: 350,
                abvTenthsPercent: 50,
                isProUnlocked: false
            )
        }

        XCTAssertEqual(try presetRepository.countActiveCustomPresets(), 3)
        XCTAssertFalse(try presetRepository.canCreateCustomPreset(isProUnlocked: false))
    }

    func testCreateCustomPresetBlocksFourthFreePreset() throws {
        let container = try makeContainer()
        let presetRepository = DrinkPresetRepository(context: container.mainContext)

        for index in 1...DrinkPresetRepository.freeCustomPresetLimit {
            _ = try presetRepository.createCustomPreset(
                name: "カスタム\(index)",
                category: .custom,
                location: .home,
                defaultPriceYen: 200,
                volumeML: 350,
                abvTenthsPercent: 50,
                isProUnlocked: false
            )
        }

        XCTAssertThrowsError(
            try presetRepository.createCustomPreset(
                name: "カスタム4",
                category: .custom,
                location: .home,
                defaultPriceYen: 200,
                volumeML: 350,
                abvTenthsPercent: 50,
                isProUnlocked: false
            )
        ) { error in
            XCTAssertEqual(error as? DrinkPresetRepositoryError, .customPresetLimitReached)
        }
    }

    func testCreateCustomPresetAllowsFourthWhenProUnlocked() throws {
        let container = try makeContainer()
        let presetRepository = DrinkPresetRepository(context: container.mainContext)

        for index in 1...DrinkPresetRepository.freeCustomPresetLimit {
            _ = try presetRepository.createCustomPreset(
                name: "カスタム\(index)",
                category: .custom,
                location: .home,
                defaultPriceYen: 200,
                volumeML: 350,
                abvTenthsPercent: 50,
                isProUnlocked: false
            )
        }

        let fourth = try presetRepository.createCustomPreset(
            name: "カスタム4",
            category: .custom,
            location: .home,
            defaultPriceYen: 250,
            volumeML: 500,
            abvTenthsPercent: 70,
            isProUnlocked: true
        )

        XCTAssertEqual(fourth.name, "カスタム4")
        XCTAssertEqual(try presetRepository.countActiveCustomPresets(), 4)
    }

    func testArchiveCustomPresetFreesFreeSlot() throws {
        let container = try makeContainer()
        let presetRepository = DrinkPresetRepository(context: container.mainContext)
        let preset = try presetRepository.createCustomPreset(
            name: "カスタム",
            category: .custom,
            location: .home,
            defaultPriceYen: 200,
            volumeML: 350,
            abvTenthsPercent: 50,
            isProUnlocked: false
        )

        try presetRepository.archiveCustomPreset(preset)

        XCTAssertEqual(try presetRepository.countActiveCustomPresets(), 0)
        XCTAssertTrue(try presetRepository.canCreateCustomPreset(isProUnlocked: false))
    }

    func testCreateOutsideCustomPresetStoresAmountOnly() throws {
        let container = try makeContainer()
        let presetRepository = DrinkPresetRepository(context: container.mainContext)

        let preset = try presetRepository.createCustomPreset(
            name: "外飲み二次会",
            category: .beer,
            location: .outside,
            defaultPriceYen: 4_000,
            volumeML: 500,
            abvTenthsPercent: 50,
            isProUnlocked: false
        )

        XCTAssertEqual(preset.category, .outside)
        XCTAssertEqual(preset.location, .outside)
        XCTAssertEqual(preset.defaultPriceYen, 4_000)
        XCTAssertEqual(preset.volumeML, 0)
        XCTAssertEqual(preset.abvTenthsPercent, 0)
    }
}

final class PresetEditValidatorTests: XCTestCase {
    func testParseAbvTenthsPercentConvertsDecimalPercentToTenths() {
        XCTAssertEqual(PresetEditValidator.parseAbvTenthsPercent("5.0"), 50)
        XCTAssertEqual(PresetEditValidator.parseAbvTenthsPercent("12.5"), 125)
        XCTAssertEqual(PresetEditValidator.parseAbvTenthsPercent("7"), 70)
    }

    func testParseAbvTenthsPercentReturnsNilForInvalidInput() {
        XCTAssertNil(PresetEditValidator.parseAbvTenthsPercent(""))
        XCTAssertNil(PresetEditValidator.parseAbvTenthsPercent("abc"))
    }

    func testAbvPercentTextFormatsTenthsAsOneDecimalPercent() {
        XCTAssertEqual(PresetEditValidator.abvPercentText(fromTenths: 50), "5.0")
        XCTAssertEqual(PresetEditValidator.abvPercentText(fromTenths: 125), "12.5")
    }
}
