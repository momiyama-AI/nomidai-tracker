import Foundation
import SwiftData

struct MonthlySummary: Equatable {
    let interval: DateInterval
    let totalAmountYen: Int
    let homeAmountYen: Int
    let outsideAmountYen: Int
    let pureAlcoholTenthsGram: Int
    let entryCount: Int
}

struct DailySpending: Equatable, Identifiable {
    let date: Date
    let totalAmountYen: Int
    let entryCount: Int

    var id: Date { date }
}

struct SummaryRepository {
    private let entryRepository: DrinkEntryRepository
    private let monthCalculator: MonthCalculator

    init(context: ModelContext, calendar: Calendar = .current) {
        self.entryRepository = DrinkEntryRepository(context: context)
        self.monthCalculator = MonthCalculator(calendar: calendar)
    }

    func monthlySummary(containing date: Date) throws -> MonthlySummary {
        let interval = monthCalculator.monthInterval(containing: date)
        let entries = try entryRepository.fetchEntries(from: interval.start, to: interval.end)

        let totalAmountYen = entries.reduce(0) { $0 + $1.amountYen }
        let homeAmountYen = entries
            .filter { $0.locationRawValue == DrinkLocation.home.rawValue }
            .reduce(0) { $0 + $1.amountYen }
        let outsideAmountYen = entries
            .filter { $0.locationRawValue == DrinkLocation.outside.rawValue }
            .reduce(0) { $0 + $1.amountYen }
        let pureAlcoholTenthsGram = entries.reduce(0) { $0 + $1.pureAlcoholTenthsGram }

        return MonthlySummary(
            interval: interval,
            totalAmountYen: totalAmountYen,
            homeAmountYen: homeAmountYen,
            outsideAmountYen: outsideAmountYen,
            pureAlcoholTenthsGram: pureAlcoholTenthsGram,
            entryCount: entries.count
        )
    }

    func previousMonthSameElapsedTotalYen(upTo date: Date) throws -> Int {
        let interval = monthCalculator.previousMonthSameElapsedInterval(upTo: date)
        let entries = try entryRepository.fetchEntries(from: interval.start, to: interval.end)
        return entries.reduce(0) { $0 + $1.amountYen }
    }

    func dryDayCount(containing date: Date, today: Date = .now) throws -> Int {
        let calendar = monthCalculator.calendar
        let monthStart = monthCalculator.startOfMonth(containing: date)
        let isCurrentMonth = calendar.isDate(date, equalTo: today, toGranularity: .month)
        let elapsedDays = isCurrentMonth
            ? monthCalculator.elapsedDaysInMonth(upTo: today)
            : monthCalculator.daysInMonth(containing: date)
        let rangeEnd = calendar.date(byAdding: .day, value: elapsedDays, to: monthStart) ?? monthStart

        let entries = try entryRepository.fetchEntries(from: monthStart, to: rangeEnd)
        let spendingDayCount = DrySpendingCalculator.distinctSpendingDayCount(
            occurredDates: entries.map(\.occurredAt),
            calendar: calendar
        )

        return DrySpendingCalculator.dryDayCount(elapsedDays: elapsedDays, distinctSpendingDayCount: spendingDayCount)
    }

    func dailySpendings(containing date: Date) throws -> [DailySpending] {
        let interval = monthCalculator.monthInterval(containing: date)
        let entries = try entryRepository.fetchEntries(from: interval.start, to: interval.end)
        let calendar = monthCalculator.calendar
        let grouped = Dictionary(grouping: entries) { calendar.startOfDay(for: $0.occurredAt) }

        return grouped.map { day, dayEntries in
            DailySpending(
                date: day,
                totalAmountYen: dayEntries.reduce(0) { $0 + $1.amountYen },
                entryCount: dayEntries.count
            )
        }
    }
}

