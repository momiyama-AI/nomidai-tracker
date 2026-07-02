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

    static func lineLocalizationKey(for level: WealthLevel, variant: Int = 0) -> String {
        let normalizedVariant = max(0, min(1, variant))
        return "character.line.\(level.rawValue).\(normalizedVariant)"
    }
}

