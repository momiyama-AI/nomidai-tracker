import Foundation

enum QuickRecordInputValidator {
    static func parseAmountYen(_ text: String) -> Int? {
        let digitsOnly = text.filter(\.isNumber)
        guard !digitsOnly.isEmpty, let value = Int(digitsOnly) else { return nil }
        return value
    }

    static func clampedAmountYen(_ value: Int) -> Int {
        max(0, value)
    }

    static func clampedQuantity(_ value: Int) -> Int {
        max(1, value)
    }
}
