import Foundation

enum WealthLevel: String, CaseIterable, Equatable, Identifiable {
    case grandRich
    case rich
    case comfortable
    case normal
    case broke
    case extremePoor

    var id: String { rawValue }

    var localizationKey: String {
        "wealth.level.\(rawValue)"
    }
}

struct LifestyleEvaluation: Equatable {
    let level: WealthLevel
    let adjustedRatio: Double
    let baseRatio: Double
    let budgetPaceRatio: Double?
}

enum CharacterEngine {
    static func spendingRatio(
        monthlySpendingYen: Int,
        baselineMonthlyYen: Int,
        elapsedDays: Int,
        daysInMonth: Int
    ) -> Double {
        let safeSpending = max(0, monthlySpendingYen)
        let safeBaseline = max(1, baselineMonthlyYen)
        let safeElapsedDays = max(1, elapsedDays)
        let safeDaysInMonth = max(1, daysInMonth)
        let proratedBaseline = Double(safeBaseline) * Double(safeElapsedDays) / Double(safeDaysInMonth)

        guard proratedBaseline > 0 else {
            return 0
        }

        return Double(safeSpending) / proratedBaseline
    }

    static func spendingRatio(
        monthlySpendingYen: Int,
        baselineMonthlyYen: Int,
        on date: Date,
        monthCalculator: MonthCalculator = MonthCalculator()
    ) -> Double {
        spendingRatio(
            monthlySpendingYen: monthlySpendingYen,
            baselineMonthlyYen: baselineMonthlyYen,
            elapsedDays: monthCalculator.elapsedDaysInMonth(upTo: date),
            daysInMonth: monthCalculator.daysInMonth(containing: date)
        )
    }

    static func wealthLevel(for ratio: Double) -> WealthLevel {
        if ratio < 0.3 {
            return .grandRich
        } else if ratio < 0.7 {
            return .rich
        } else if ratio < 1.0 {
            return .comfortable
        } else if ratio < 1.5 {
            return .normal
        } else if ratio < 2.0 {
            return .broke
        } else {
            return .extremePoor
        }
    }

    static func wealthLevel(
        monthlySpendingYen: Int,
        baselineMonthlyYen: Int,
        on date: Date,
        monthCalculator: MonthCalculator = MonthCalculator()
    ) -> WealthLevel {
        wealthLevel(
            for: spendingRatio(
                monthlySpendingYen: monthlySpendingYen,
                baselineMonthlyYen: baselineMonthlyYen,
                on: date,
                monthCalculator: monthCalculator
            )
        )
    }

    static func lifestyleEvaluation(
        monthlySpendingYen: Int,
        baselineMonthlyYen: Int,
        monthlyBudgetYen: Int?,
        dryDayCount: Int,
        pureAlcoholTenthsGram: Int,
        elapsedDays: Int,
        daysInMonth: Int
    ) -> LifestyleEvaluation {
        let safeElapsedDays = max(1, elapsedDays)
        let safeDaysInMonth = max(1, daysInMonth)
        let safeDryDayCount = min(max(0, dryDayCount), safeElapsedDays)
        let safePureAlcoholTenthsGram = max(0, pureAlcoholTenthsGram)

        let baseRatio = spendingRatio(
            monthlySpendingYen: monthlySpendingYen,
            baselineMonthlyYen: baselineMonthlyYen,
            elapsedDays: safeElapsedDays,
            daysInMonth: safeDaysInMonth
        )

        let budgetPaceRatio: Double?
        let primaryRatio: Double
        if let monthlyBudgetYen, monthlyBudgetYen > 0 {
            let budgetStatus = BudgetCalculator.status(
                budgetYen: monthlyBudgetYen,
                spentYen: monthlySpendingYen,
                elapsedDays: safeElapsedDays,
                daysInMonth: safeDaysInMonth
            )
            budgetPaceRatio = budgetStatus.paceRatio
            primaryRatio = budgetStatus.paceRatio
        } else {
            budgetPaceRatio = nil
            primaryRatio = baseRatio
        }

        let expectedDryDays = max(1, safeElapsedDays / 4)
        let manyDryDays = max(2, safeElapsedDays / 3)
        var adjustedRatio = primaryRatio

        if safeDryDayCount >= manyDryDays {
            adjustedRatio -= 0.12
        } else if safeDryDayCount >= expectedDryDays {
            adjustedRatio -= 0.04
        } else if safeDryDayCount == 0 && safeElapsedDays >= 4 {
            adjustedRatio += 0.08
        }

        let averagePureAlcoholTenthsGram = safePureAlcoholTenthsGram / safeElapsedDays
        if averagePureAlcoholTenthsGram >= 500 {
            adjustedRatio += 0.10
        } else if averagePureAlcoholTenthsGram <= 100 && safeDryDayCount >= expectedDryDays {
            adjustedRatio -= 0.04
        }

        let clampedRatio = max(0, adjustedRatio)
        return LifestyleEvaluation(
            level: wealthLevel(for: clampedRatio),
            adjustedRatio: clampedRatio,
            baseRatio: baseRatio,
            budgetPaceRatio: budgetPaceRatio
        )
    }

    static func lifestyleEvaluation(
        monthlySpendingYen: Int,
        baselineMonthlyYen: Int,
        monthlyBudgetYen: Int?,
        dryDayCount: Int,
        pureAlcoholTenthsGram: Int,
        on date: Date,
        monthCalculator: MonthCalculator = MonthCalculator()
    ) -> LifestyleEvaluation {
        lifestyleEvaluation(
            monthlySpendingYen: monthlySpendingYen,
            baselineMonthlyYen: baselineMonthlyYen,
            monthlyBudgetYen: monthlyBudgetYen,
            dryDayCount: dryDayCount,
            pureAlcoholTenthsGram: pureAlcoholTenthsGram,
            elapsedDays: monthCalculator.elapsedDaysInMonth(upTo: date),
            daysInMonth: monthCalculator.daysInMonth(containing: date)
        )
    }

    static func lineLocalizationKey(for level: WealthLevel, variant: Int = 0) -> String {
        let normalizedVariant = max(0, min(1, variant))
        return "character.line.\(level.rawValue).\(normalizedVariant)"
    }
}
