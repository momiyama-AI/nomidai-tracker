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

    func testLifestyleEvaluationUsesBudgetPaceWhenBudgetIsConfigured() {
        let evaluation = CharacterEngine.lifestyleEvaluation(
            monthlySpendingYen: 1_500,
            baselineMonthlyYen: 4_500,
            monthlyBudgetYen: 9_000,
            dryDayCount: 1,
            pureAlcoholTenthsGram: 1_500,
            elapsedDays: 10,
            daysInMonth: 30
        )

        XCTAssertEqual(evaluation.baseRatio, 1.0, accuracy: 0.000_001)
        XCTAssertEqual(evaluation.budgetPaceRatio, 0.5, accuracy: 0.000_001)
        XCTAssertEqual(evaluation.adjustedRatio, 0.5, accuracy: 0.000_001)
        XCTAssertEqual(evaluation.level, .rich)
    }

    func testLifestyleEvaluationMovesRicherWithManyDryDays() {
        let evaluation = CharacterEngine.lifestyleEvaluation(
            monthlySpendingYen: 1_050,
            baselineMonthlyYen: 3_000,
            monthlyBudgetYen: nil,
            dryDayCount: 4,
            pureAlcoholTenthsGram: 600,
            elapsedDays: 10,
            daysInMonth: 30
        )

        XCTAssertEqual(evaluation.baseRatio, 1.05, accuracy: 0.000_001)
        XCTAssertEqual(evaluation.adjustedRatio, 0.89, accuracy: 0.000_001)
        XCTAssertEqual(evaluation.level, .comfortable)
    }

    func testLifestyleEvaluationMovesPoorerWithNoDryDaysAndHighPureAlcohol() {
        let evaluation = CharacterEngine.lifestyleEvaluation(
            monthlySpendingYen: 1_420,
            baselineMonthlyYen: 3_000,
            monthlyBudgetYen: nil,
            dryDayCount: 0,
            pureAlcoholTenthsGram: 5_200,
            elapsedDays: 10,
            daysInMonth: 30
        )

        XCTAssertEqual(evaluation.baseRatio, 1.42, accuracy: 0.000_001)
        XCTAssertEqual(evaluation.adjustedRatio, 1.6, accuracy: 0.000_001)
        XCTAssertEqual(evaluation.level, .broke)
    }

    func testLifestyleEvaluationIgnoresZeroBudgetAndAvoidsDivisionByZero() {
        let evaluation = CharacterEngine.lifestyleEvaluation(
            monthlySpendingYen: 0,
            baselineMonthlyYen: 0,
            monthlyBudgetYen: 0,
            dryDayCount: 99,
            pureAlcoholTenthsGram: -1,
            elapsedDays: 0,
            daysInMonth: 0
        )

        XCTAssertNil(evaluation.budgetPaceRatio)
        XCTAssertTrue(evaluation.adjustedRatio.isFinite)
        XCTAssertEqual(evaluation.adjustedRatio, 0)
        XCTAssertEqual(evaluation.level, .grandRich)
    }
}
