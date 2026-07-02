import Foundation

struct MonthCalculator {
    var calendar: Calendar

    init(calendar: Calendar = .current) {
        self.calendar = calendar
    }

    func startOfMonth(containing date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components) ?? calendar.startOfDay(for: date)
    }

    func startOfNextMonth(containing date: Date) -> Date {
        calendar.date(
            byAdding: .month,
            value: 1,
            to: startOfMonth(containing: date)
        ) ?? startOfMonth(containing: date)
    }

    func endOfMonth(containing date: Date) -> Date {
        calendar.date(
            byAdding: .second,
            value: -1,
            to: startOfNextMonth(containing: date)
        ) ?? date
    }

    func monthInterval(containing date: Date) -> DateInterval {
        DateInterval(
            start: startOfMonth(containing: date),
            end: startOfNextMonth(containing: date)
        )
    }

    func daysInMonth(containing date: Date) -> Int {
        calendar.range(of: .day, in: .month, for: date)?.count ?? 30
    }

    func elapsedDaysInMonth(upTo date: Date) -> Int {
        min(max(calendar.component(.day, from: date), 1), daysInMonth(containing: date))
    }

    func proratedBaselineYen(baselineMonthlyYen: Int, upTo date: Date) -> Int {
        let safeBaseline = max(1, baselineMonthlyYen)
        let elapsedDays = max(1, elapsedDaysInMonth(upTo: date))
        let monthDays = max(1, daysInMonth(containing: date))
        return safeBaseline * elapsedDays / monthDays
    }

    func previousMonthSameElapsedInterval(upTo date: Date) -> DateInterval {
        let currentElapsedDays = elapsedDaysInMonth(upTo: date)
        let previousMonthDate = calendar.date(byAdding: .month, value: -1, to: date) ?? date
        let previousStart = startOfMonth(containing: previousMonthDate)
        let cappedElapsedDays = min(
            max(1, currentElapsedDays),
            daysInMonth(containing: previousMonthDate)
        )
        let previousEnd = calendar.date(
            byAdding: .day,
            value: cappedElapsedDays,
            to: previousStart
        ) ?? previousStart

        return DateInterval(start: previousStart, end: previousEnd)
    }
}

