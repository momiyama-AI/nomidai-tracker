import Foundation

enum AlcoholCalculator {
    static func pureAlcoholTenthsGram(volumeML: Int, abvTenthsPercent: Int) -> Int {
        max(0, volumeML) * max(0, abvTenthsPercent) * 8 / 1_000
    }

    static func formattedTenthsGram(_ tenthsGram: Int) -> String {
        let value = max(0, tenthsGram)
        return "\(value / 10).\(value % 10)g"
    }
}

