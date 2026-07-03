import Foundation

enum PresetEditValidator {
    static func parsePriceYen(_ text: String) -> Int? {
        QuickRecordInputValidator.parseAmountYen(text)
    }

    static func parseVolumeML(_ text: String) -> Int? {
        QuickRecordInputValidator.parseAmountYen(text)
    }

    static func parseAbvTenthsPercent(_ text: String) -> Int? {
        let normalized = text.replacingOccurrences(of: "%", with: "")
        guard let value = Double(normalized), value.isFinite, value >= 0 else { return nil }
        return Int((value * 10).rounded())
    }

    static func abvPercentText(fromTenths abvTenthsPercent: Int) -> String {
        String(format: "%.1f", Double(abvTenthsPercent) / 10)
    }

    static func clampedPriceYen(_ value: Int) -> Int {
        max(0, value)
    }

    static func clampedVolumeML(_ value: Int) -> Int {
        max(0, value)
    }

    static func clampedAbvTenthsPercent(_ value: Int) -> Int {
        max(0, value)
    }
}
