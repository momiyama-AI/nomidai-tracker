import XCTest
@testable import NomidaiTracker

final class CharacterEngineTests: XCTestCase {
    func testWealthLevelBoundaryValues() {
        XCTAssertEqual(CharacterEngine.wealthLevel(for: 0.299_999), .grandRich)
        XCTAssertEqual(CharacterEngine.wealthLevel(for: 0.3), .rich)
        XCTAssertEqual(CharacterEngine.wealthLevel(for: 0.7), .comfortable)
        XCTAssertEqual(CharacterEngine.wealthLevel(for: 1.0), .normal)
        XCTAssertEqual(CharacterEngine.wealthLevel(for: 1.5), .broke)
        XCTAssertEqual(CharacterEngine.wealthLevel(for: 2.0), .extremePoor)
    }

    func testZeroSpendingReturnsZeroRatio() {
        let ratio = CharacterEngine.spendingRatio(
            monthlySpendingYen: 0,
            baselineMonthlyYen: 5_500,
            elapsedDays: 10,
            daysInMonth: 30
        )

        XCTAssertEqual(ratio, 0)
        XCTAssertEqual(CharacterEngine.wealthLevel(for: ratio), .grandRich)
    }

    func testTinyBaselineAvoidsDivisionByZero() {
        let zeroBaselineRatio = CharacterEngine.spendingRatio(
            monthlySpendingYen: 100,
            baselineMonthlyYen: 0,
            elapsedDays: 1,
            daysInMonth: 31
        )

        let negativeBaselineRatio = CharacterEngine.spendingRatio(
            monthlySpendingYen: 100,
            baselineMonthlyYen: -10,
            elapsedDays: 0,
            daysInMonth: 0
        )

        XCTAssertTrue(zeroBaselineRatio.isFinite)
        XCTAssertTrue(negativeBaselineRatio.isFinite)
        XCTAssertGreaterThan(zeroBaselineRatio, 0)
        XCTAssertGreaterThan(negativeBaselineRatio, 0)
    }

    func testFirstDayProratedRatio() {
        let ratio = CharacterEngine.spendingRatio(
            monthlySpendingYen: 100,
            baselineMonthlyYen: 3_100,
            elapsedDays: 1,
            daysInMonth: 31
        )

        XCTAssertEqual(ratio, 1.0, accuracy: 0.000_001)
        XCTAssertEqual(CharacterEngine.wealthLevel(for: ratio), .normal)
    }
}

