import XCTest
@testable import NomidaiTracker

final class DrySpendingCalculatorTests: XCTestCase {
    func testDryDayCountSubtractsSpendingDays() {
        XCTAssertEqual(DrySpendingCalculator.dryDayCount(elapsedDays: 10, distinctSpendingDayCount: 3), 7)
    }

    func testDryDayCountNeverGoesNegative() {
        XCTAssertEqual(DrySpendingCalculator.dryDayCount(elapsedDays: 5, distinctSpendingDayCount: 8), 0)
    }

    func testFirstDayOfMonthWithNoEntriesCountsAsOneDryDay() {
        XCTAssertEqual(DrySpendingCalculator.dryDayCount(elapsedDays: 1, distinctSpendingDayCount: 0), 1)
    }

    func testDistinctSpendingDayCountDeduplicatesSameDayEntries() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!

        let morning = try XCTUnwrap(DateComponents(
            calendar: calendar, timeZone: calendar.timeZone, year: 2026, month: 7, day: 3, hour: 9
        ).date)
        let night = try XCTUnwrap(DateComponents(
            calendar: calendar, timeZone: calendar.timeZone, year: 2026, month: 7, day: 3, hour: 22
        ).date)
        let otherDay = try XCTUnwrap(DateComponents(
            calendar: calendar, timeZone: calendar.timeZone, year: 2026, month: 7, day: 4, hour: 9
        ).date)

        let count = DrySpendingCalculator.distinctSpendingDayCount(
            occurredDates: [morning, night, otherDay],
            calendar: calendar
        )

        XCTAssertEqual(count, 2)
    }
}
