import SwiftData
import XCTest
@testable import NomidaiTracker

@MainActor
final class RepositoryBootstrapTests: XCTestCase {
    func testDefaultPresetSeedingIsIdempotent() throws {
        let container = try AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
        let repository = DrinkPresetRepository(context: container.mainContext)

        try repository.seedDefaultPresetsIfNeeded()
        try repository.seedDefaultPresetsIfNeeded()

        let presets = try repository.fetchActivePresets()
        XCTAssertEqual(presets.filter(\.isDefault).count, 8)
        XCTAssertEqual(presets.first?.name, "缶ビール350")
        XCTAssertEqual(presets.last?.name, "外飲み")
        XCTAssertEqual(presets.last?.defaultPriceYen, 3_000)
        XCTAssertEqual(presets.last?.volumeML, 0)
        XCTAssertEqual(presets.last?.abvTenthsPercent, 0)
    }

    func testSettingsDefaultBaseline() throws {
        let container = try AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
        let repository = SettingsRepository(context: container.mainContext)

        let settings = try repository.fetchOrCreateSettings()

        XCTAssertEqual(settings.baselineMonthlyYen, 5_500)
        XCTAssertNil(settings.monthlyBudgetYen)
    }
}

