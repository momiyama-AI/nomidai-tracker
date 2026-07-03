import Foundation

struct BudgetStatus: Equatable {
    let budgetYen: Int
    let spentYen: Int
    let remainingYen: Int
    let paceRatio: Double
}

enum BudgetCalculator {
    static func status(
        budgetYen: Int,
        spentYen: Int,
        elapsedDays: Int,
        daysInMonth: Int
    ) -> BudgetStatus {
        let safeSpent = max(0, spentYen)
        let remainingYen = budgetYen - safeSpent
        let safeBudget = max(1, budgetYen)
        let safeElapsedDays = max(1, elapsedDays)
        let safeDaysInMonth = max(1, daysInMonth)
        let proratedBudgetYen = Double(safeBudget) * Double(safeElapsedDays) / Double(safeDaysInMonth)
        let paceRatio = proratedBudgetYen > 0 ? Double(safeSpent) / proratedBudgetYen : 0

        return BudgetStatus(
            budgetYen: budgetYen,
            spentYen: safeSpent,
            remainingYen: remainingYen,
            paceRatio: paceRatio
        )
    }

    static func status(
        budgetYen: Int,
        spentYen: Int,
        on date: Date,
        monthCalculator: MonthCalculator = MonthCalculator()
    ) -> BudgetStatus {
        status(
            budgetYen: budgetYen,
            spentYen: spentYen,
            elapsedDays: monthCalculator.elapsedDaysInMonth(upTo: date),
            daysInMonth: monthCalculator.daysInMonth(containing: date)
        )
    }
}
