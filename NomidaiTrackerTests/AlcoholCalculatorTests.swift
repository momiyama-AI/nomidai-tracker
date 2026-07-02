import XCTest
@testable import NomidaiTracker

final class AlcoholCalculatorTests: XCTestCase {
    func testPureAlcoholCalculationUsesIntegerFormula() {
        XCTAssertEqual(
            AlcoholCalculator.pureAlcoholTenthsGram(volumeML: 350, abvTenthsPercent: 50),
            140
        )
        XCTAssertEqual(
            AlcoholCalculator.pureAlcoholTenthsGram(volumeML: 120, abvTenthsPercent: 125),
            120
        )
    }

    func testOutsideDrinkDefaultsToZeroPureAlcohol() {
        XCTAssertEqual(
            AlcoholCalculator.pureAlcoholTenthsGram(volumeML: 0, abvTenthsPercent: 0),
            0
        )
    }

    func testFormattedTenthsGram() {
        XCTAssertEqual(AlcoholCalculator.formattedTenthsGram(140), "14.0g")
        XCTAssertEqual(AlcoholCalculator.formattedTenthsGram(7), "0.7g")
    }
}

