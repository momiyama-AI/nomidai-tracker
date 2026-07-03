import XCTest
@testable import NomidaiTracker

final class CSVExporterTests: XCTestCase {
    func testEscapeLeavesPlainTextUnquoted() {
        XCTAssertEqual(CSVExporter.escape("beer"), "beer")
    }

    func testEscapeQuotesComma() {
        XCTAssertEqual(CSVExporter.escape("beer,wine"), "\"beer,wine\"")
    }

    func testEscapeDoublesQuotes() {
        XCTAssertEqual(CSVExporter.escape("say \"cheers\""), "\"say \"\"cheers\"\"\"")
    }

    func testEscapeQuotesNewline() {
        XCTAssertEqual(CSVExporter.escape("one\ntwo"), "\"one\ntwo\"")
    }

    func testExportSortsRowsAndEscapesMemo() {
        let older = DrinkEntry(
            occurredAt: Date(timeIntervalSince1970: 100),
            presetNameSnapshot: "ビール",
            category: .beer,
            location: .home,
            quantity: 1,
            amountYen: 220,
            volumeML: 350,
            abvTenthsPercent: 50,
            memo: "冷蔵庫,上段"
        )
        let newer = DrinkEntry(
            occurredAt: Date(timeIntervalSince1970: 200),
            presetNameSnapshot: "外飲み",
            category: .outside,
            location: .outside,
            quantity: 1,
            amountYen: 3_000,
            volumeML: 0,
            abvTenthsPercent: 0,
            memo: "友人"
        )

        let csv = CSVExporter().export(entries: [newer, older])

        XCTAssertTrue(csv.contains("\"冷蔵庫,上段\""))
        XCTAssertLessThan(
            csv.range(of: "1970-01-01T00:01:40Z")!.lowerBound,
            csv.range(of: "1970-01-01T00:03:20Z")!.lowerBound
        )
    }
}
