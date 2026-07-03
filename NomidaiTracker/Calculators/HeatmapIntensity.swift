import Foundation

enum HeatmapIntensity {
    static func level(amountYen: Int, maxAmountYen: Int) -> Double {
        guard maxAmountYen > 0, amountYen > 0 else { return 0 }
        return min(1.0, Double(amountYen) / Double(maxAmountYen))
    }
}
