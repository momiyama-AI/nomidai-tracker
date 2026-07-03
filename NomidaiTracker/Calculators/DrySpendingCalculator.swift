import Foundation

enum DrySpendingCalculator {
    static func distinctSpendingDayCount(occurredDates: [Date], calendar: Calendar = .current) -> Int {
        Set(occurredDates.map { calendar.startOfDay(for: $0) }).count
    }

    static func dryDayCount(elapsedDays: Int, distinctSpendingDayCount: Int) -> Int {
        max(0, max(0, elapsedDays) - max(0, distinctSpendingDayCount))
    }
}
