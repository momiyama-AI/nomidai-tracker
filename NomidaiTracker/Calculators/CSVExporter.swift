import Foundation

struct CSVExporter {
    func export(entries: [DrinkEntry]) -> String {
        let header = [
            "occurredAt",
            "presetName",
            "category",
            "location",
            "quantity",
            "amountYen",
            "volumeML",
            "abvTenthsPercent",
            "pureAlcoholTenthsGram",
            "memo"
        ]
        let sortedEntries = entries.sorted { $0.occurredAt < $1.occurredAt }
        let rows = sortedEntries.map(row)
        return ([header] + rows)
            .map { $0.map(Self.escape).joined(separator: ",") }
            .joined(separator: "\n")
    }

    static func escape(_ field: String) -> String {
        let needsQuoting = field.contains(",") || field.contains("\"") || field.contains("\n") || field.contains("\r")
        guard needsQuoting else { return field }
        return "\"\(field.replacingOccurrences(of: "\"", with: "\"\""))\""
    }

    private func row(for entry: DrinkEntry) -> [String] {
        [
            ISO8601DateFormatter().string(from: entry.occurredAt),
            entry.presetNameSnapshot,
            entry.categoryRawValue,
            entry.locationRawValue,
            String(entry.quantity),
            String(entry.amountYen),
            String(entry.volumeML),
            String(entry.abvTenthsPercent),
            String(entry.pureAlcoholTenthsGram),
            entry.memo
        ]
    }
}
