import SwiftData
import XCTest
@testable import NomidaiTracker

@MainActor
final class SummaryRepositoryTests: XCTestCase {
    private var calendar: Calendar = {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        return calendar
    }()

    private func makeContainer() throws -> ModelContainer {
        try AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    }

    private func date(year: Int, month: Int, day: Int, hour: Int = 12) throws -> Date {
        try XCTUnwrap(DateComponents(
            calendar: calendar, timeZone: calendar.timeZone, year: year, month: month, day: day, hour: hour
        ).date)
    }

    func testDryDayCountExcludesFutureDays() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let today = try date(year: 2026, month: 7, day: 10)
        let repository = SummaryRepository(context: context, calendar: calendar)

        let count = try repository.dryDayCount(containing: today, today: today)

        XCTAssertEqual(count, 10)
    }

    func testDryDayCountExcludesDaysWithEntries() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let today = try date(year: 2026, month: 7, day: 10)
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets()[0]
        let entryRepository = DrinkEntryRepository(context: context)
        try entryRepository.createEntry(from: preset, amountYen: 220, occurredAt: try date(year: 2026, month: 7, day: 3, hour: 9))
        try entryRepository.createEntry(from: preset, amountYen: 220, occurredAt: try date(year: 2026, month: 7, day: 3, hour: 20))

        let repository = SummaryRepository(context: context, calendar: calendar)
        let count = try repository.dryDayCount(containing: today, today: today)

        XCTAssertEqual(count, 9)
    }

    func testFirstDayOfMonthDryDayCount() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let today = try date(year: 2026, month: 7, day: 1)
        let repository = SummaryRepository(context: context, calendar: calendar)

        let count = try repository.dryDayCount(containing: today, today: today)

        XCTAssertEqual(count, 1)
    }

    func testPreviousMonthSameElapsedTotalMatchesExpectedInterval() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let today = try date(year: 2026, month: 7, day: 10)
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets()[0]
        let entryRepository = DrinkEntryRepository(context: context)
        try entryRepository.createEntry(from: preset, amountYen: 500, occurredAt: try date(year: 2026, month: 6, day: 5))
        try entryRepository.createEntry(from: preset, amountYen: 300, occurredAt: try date(year: 2026, month: 6, day: 15))

        let repository = SummaryRepository(context: context, calendar: calendar)
        let total = try repository.previousMonthSameElapsedTotalYen(upTo: today)

        XCTAssertEqual(total, 500)
    }

    func testDailySpendingsSumsHomeAndOutsideEntries() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let homePreset = try XCTUnwrap(presetRepository.fetchActivePresets().first { $0.location == .home })
        let outsidePreset = try XCTUnwrap(presetRepository.fetchActivePresets().first { $0.location == .outside })
        let entryRepository = DrinkEntryRepository(context: context)
        let day = try date(year: 2026, month: 7, day: 5, hour: 9)
        try entryRepository.createEntry(from: homePreset, amountYen: 220, occurredAt: day)
        try entryRepository.createEntry(from: outsidePreset, amountYen: 3_000, occurredAt: try date(year: 2026, month: 7, day: 5, hour: 21))

        let repository = SummaryRepository(context: context, calendar: calendar)
        let spendings = try repository.dailySpendings(containing: day)
        let daySpending = try XCTUnwrap(spendings.first { calendar.isDate($0.date, inSameDayAs: day) })

        XCTAssertEqual(daySpending.totalAmountYen, 3_220)
        XCTAssertEqual(daySpending.entryCount, 2)
    }

    func testCharacterEngineConnectsWithMonthlySummaryTotal() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let today = try date(year: 2026, month: 7, day: 10)
        let presetRepository = DrinkPresetRepository(context: context)
        try presetRepository.seedDefaultPresetsIfNeeded()
        let preset = try presetRepository.fetchActivePresets()[0]
        let entryRepository = DrinkEntryRepository(context: context)
        try entryRepository.createEntry(from: preset, amountYen: 5_000, occurredAt: today)

        let repository = SummaryRepository(context: context, calendar: calendar)
        let summary = try repository.monthlySummary(containing: today)
        let monthCalculator = MonthCalculator(calendar: calendar)

        let level = CharacterEngine.wealthLevel(
            monthlySpendingYen: summary.totalAmountYen,
            baselineMonthlyYen: 5_500,
            on: today,
            monthCalculator: monthCalculator
        )

        XCTAssertEqual(level, .extremePoor)
    }
}
