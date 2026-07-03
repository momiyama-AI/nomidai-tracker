import XCTest
@testable import NomidaiTracker

final class BudgetCalculatorTests: XCTestCase {
    func testRemainingYenSubtractsSpentFromBudget() {
        let status = BudgetCalculator.status(budgetYen: 10_000, spentYen: 3_000, elapsedDays: 10, daysInMonth: 30)

        XCTAssertEqual(status.remainingYen, 7_000)
    }

    func testRemainingYenCanGoNegativeWhenOverBudget() {
        let status = BudgetCalculator.status(budgetYen: 5_000, spentYen: 8_000, elapsedDays: 15, daysInMonth: 30)

        XCTAssertEqual(status.remainingYen, -3_000)
    }

    func testPaceRatioMatchesProratedBudget() {
        let status = BudgetCalculator.status(budgetYen: 3_000, spentYen: 1_000, elapsedDays: 10, daysInMonth: 30)

        XCTAssertEqual(status.paceRatio, 1.0, accuracy: 0.000_001)
    }

    func testPaceRatioAboveOneWhenSpendingFasterThanBudget() {
        let status = BudgetCalculator.status(budgetYen: 3_000, spentYen: 2_000, elapsedDays: 10, daysInMonth: 30)

        XCTAssertEqual(status.paceRatio, 2.0, accuracy: 0.000_001)
    }

    func testTinyBudgetAvoidsDivisionByZero() {
        let status = BudgetCalculator.status(budgetYen: 0, spentYen: 100, elapsedDays: 0, daysInMonth: 0)

        XCTAssertTrue(status.paceRatio.isFinite)
        XCTAssertGreaterThan(status.paceRatio, 0)
    }
}
