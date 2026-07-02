import XCTest
@testable import NomidaiTracker

final class MonthCalculatorTests: XCTestCase {
    func testFirstDayElapsedDaysIsOne() throws {
        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!
        let date = try XCTUnwrap(DateComponents(
            calendar: calendar,
            timeZone: calendar.timeZone,
            year: 2026,
            month: 7,
            day: 1,
            hour: 12
        ).date)
        let calculator = MonthCalculator(calendar: calendar)

        XCTAssertEqual(calculator.elapsedDaysInMonth(upTo: date), 1)
        XCTAssertEqual(calculator.daysInMonth(containing: date), 31)
        XCTAssertEqual(calculator.proratedBaselineYen(baselineMonthlyYen: 3_100, upTo: date), 100)
    }

    func testJSTMonthBoundary() throws {
        var jstCalendar = Calendar(identifier: .gregorian)
        jstCalendar.timeZone = TimeZone(identifier: "Asia/Tokyo")!

        var utcCalendar = Calendar(identifier: .gregorian)
        utcCalendar.timeZone = TimeZone(secondsFromGMT: 0)!

        let beforeBoundary = try XCTUnwrap(DateComponents(
            calendar: utcCalendar,
            timeZone: utcCalendar.timeZone,
            year: 2026,
            month: 7,
            day: 31,
            hour: 14,
            minute: 59
        ).date)
        let atBoundary = try XCTUnwrap(DateComponents(
            calendar: utcCalendar,
            timeZone: utcCalendar.timeZone,
            year: 2026,
            month: 7,
            day: 31,
            hour: 15,
            minute: 0
        ).date)

        let calculator = MonthCalculator(calendar: jstCalendar)

        XCTAssertEqual(jstCalendar.component(.month, from: beforeBoundary), 7)
        XCTAssertEqual(jstCalendar.component(.day, from: beforeBoundary), 31)
        XCTAssertEqual(calculator.elapsedDaysInMonth(upTo: beforeBoundary), 31)

        XCTAssertEqual(jstCalendar.component(.month, from: atBoundary), 8)
        XCTAssertEqual(jstCalendar.component(.day, from: atBoundary), 1)
        XCTAssertEqual(calculator.elapsedDaysInMonth(upTo: atBoundary), 1)
        XCTAssertEqual(calculator.daysInMonth(containing: atBoundary), 31)
    }
}

