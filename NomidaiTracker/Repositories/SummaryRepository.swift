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
}

