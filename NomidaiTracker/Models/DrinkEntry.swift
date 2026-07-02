import Foundation
import SwiftData

@Model
final class DrinkEntry {
    @Attribute(.unique) var id: UUID
    var occurredAt: Date
    var presetID: UUID?
    var presetNameSnapshot: String
    var categoryRawValue: String
    var locationRawValue: String
    var quantity: Int
    var amountYen: Int
    var volumeML: Int
    var abvTenthsPercent: Int
    var pureAlcoholTenthsGram: Int
    var memo: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        occurredAt: Date = .now,
        presetID: UUID? = nil,
        presetNameSnapshot: String,
        category: DrinkCategory,
        location: DrinkLocation,
        quantity: Int,
        amountYen: Int,
        volumeML: Int,
        abvTenthsPercent: Int,
        pureAlcoholTenthsGram: Int? = nil,
        memo: String = "",
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        let safeQuantity = max(1, quantity)
        let safeVolumeML = max(0, volumeML)
        let safeABV = max(0, abvTenthsPercent)

        self.id = id
        self.occurredAt = occurredAt
        self.presetID = presetID
        self.presetNameSnapshot = presetNameSnapshot
        self.categoryRawValue = category.rawValue
        self.locationRawValue = location.rawValue
        self.quantity = safeQuantity
        self.amountYen = max(0, amountYen)
        self.volumeML = safeVolumeML
        self.abvTenthsPercent = safeABV
        self.pureAlcoholTenthsGram = pureAlcoholTenthsGram ?? AlcoholCalculator.pureAlcoholTenthsGram(
            volumeML: safeVolumeML * safeQuantity,
            abvTenthsPercent: safeABV
        )
        self.memo = memo
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var category: DrinkCategory {
        get { DrinkCategory(rawValue: categoryRawValue) ?? .custom }
        set { categoryRawValue = newValue.rawValue }
    }

    var location: DrinkLocation {
        get { DrinkLocation(rawValue: locationRawValue) ?? .home }
        set { locationRawValue = newValue.rawValue }
    }
}

