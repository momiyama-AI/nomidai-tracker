import Foundation

enum CurrencyFormatter {
    private static let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.usesGroupingSeparator = true
        return formatter
    }()

    static func yenString(_ amountYen: Int) -> String {
        let number = numberFormatter.string(from: NSNumber(value: amountYen)) ?? String(amountYen)
        return "¥\(number)"
    }
}
