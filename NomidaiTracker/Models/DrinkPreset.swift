import Foundation
import SwiftData

@Model
final class DrinkPreset {
    @Attribute(.unique) var id: UUID
    var name: String
    var categoryRawValue: String
    var locationRawValue: String
    var defaultPriceYen: Int
    var volumeML: Int
    var abvTenthsPercent: Int
    var iconName: String
    var colorName: String
    var isDefault: Bool
    var isArchived: Bool
    var sortIndex: Int
    var usageCount: Int
    var lastUsedAt: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String,
        category: DrinkCategory,
        location: DrinkLocation,
        defaultPriceYen: Int,
        volumeML: Int,
        abvTenthsPercent: Int,
        iconName: String,
        colorName: String,
        isDefault: Bool,
        isArchived: Bool = false,
        sortIndex: Int,
        usageCount: Int = 0,
        lastUsedAt: Date? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.categoryRawValue = category.rawValue
        self.locationRawValue = location.rawValue
        self.defaultPriceYen = max(0, defaultPriceYen)
        self.volumeML = max(0, volumeML)
        self.abvTenthsPercent = max(0, abvTenthsPercent)
        self.iconName = iconName
        self.colorName = colorName
        self.isDefault = isDefault
        self.isArchived = isArchived
        self.sortIndex = sortIndex
        self.usageCount = max(0, usageCount)
        self.lastUsedAt = lastUsedAt
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

