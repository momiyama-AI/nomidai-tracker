import XCTest
@testable import NomidaiTracker

final class HeatmapIntensityTests: XCTestCase {
    func testZeroAmountHasZeroIntensity() {
        XCTAssertEqual(HeatmapIntensity.level(amountYen: 0, maxAmountYen: 1_000), 0)
    }

    func testZeroMaxAmountAvoidsDivisionByZero() {
        XCTAssertEqual(HeatmapIntensity.level(amountYen: 500, maxAmountYen: 0), 0)
    }

    func testMaxAmountProducesFullIntensity() {
        XCTAssertEqual(HeatmapIntensity.level(amountYen: 1_000, maxAmountYen: 1_000), 1.0, accuracy: 0.000_1)
    }

    func testIntensityNeverExceedsOne() {
        XCTAssertEqual(HeatmapIntensity.level(amountYen: 5_000, maxAmountYen: 1_000), 1.0, accuracy: 0.000_1)
    }
}
