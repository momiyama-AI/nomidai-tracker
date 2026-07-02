import Foundation
import SwiftData

struct DrinkPresetRepository {
    struct DefaultDrinkPreset {
        let id: UUID
        let name: String
        let category: DrinkCategory
        let location: DrinkLocation
        let defaultPriceYen: Int
        let volumeML: Int
        let abvTenthsPercent: Int
        let iconName: String
        let colorName: String
        let sortIndex: Int

        func makePreset(now: Date) -> DrinkPreset {
            DrinkPreset(
                id: id,
                name: name,
                category: category,
                location: location,
                defaultPriceYen: defaultPriceYen,
                volumeML: volumeML,
                abvTenthsPercent: abvTenthsPercent,
                iconName: iconName,
                colorName: colorName,
                isDefault: true,
                sortIndex: sortIndex,
                createdAt: now,
                updatedAt: now
            )
        }
    }

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    static let defaultPresets: [DefaultDrinkPreset] = [
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000001")!,
            name: "缶ビール350",
            category: .beer,
            location: .home,
            defaultPriceYen: 220,
            volumeML: 350,
            abvTenthsPercent: 50,
            iconName: "mug.fill",
            colorName: "beer",
            sortIndex: 0
        ),
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000002")!,
            name: "缶ビール500",
            category: .beer,
            location: .home,
            defaultPriceYen: 300,
            volumeML: 500,
            abvTenthsPercent: 50,
            iconName: "mug.fill",
            colorName: "beer",
            sortIndex: 1
        ),
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000003")!,
            name: "缶チューハイ350",
            category: .chuhai,
            location: .home,
            defaultPriceYen: 170,
            volumeML: 350,
            abvTenthsPercent: 70,
            iconName: "sparkles",
            colorName: "chuhai",
            sortIndex: 2
        ),
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000004")!,
            name: "缶チューハイ500",
            category: .chuhai,
            location: .home,
            defaultPriceYen: 230,
            volumeML: 500,
            abvTenthsPercent: 70,
            iconName: "sparkles",
            colorName: "chuhai",
            sortIndex: 3
        ),
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000005")!,
            name: "ハイボール",
            category: .highball,
            location: .home,
            defaultPriceYen: 210,
            volumeML: 350,
            abvTenthsPercent: 70,
            iconName: "tumbler.fill",
            colorName: "highball",
            sortIndex: 4
        ),
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000006")!,
            name: "日本酒1合",
            category: .sake,
            location: .home,
            defaultPriceYen: 250,
            volumeML: 180,
            abvTenthsPercent: 150,
            iconName: "cup.and.saucer.fill",
            colorName: "sake",
            sortIndex: 5
        ),
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000007")!,
            name: "ワイングラス",
            category: .wine,
            location: .home,
            defaultPriceYen: 300,
            volumeML: 120,
            abvTenthsPercent: 120,
            iconName: "wineglass.fill",
            colorName: "wine",
            sortIndex: 6
        ),
        DefaultDrinkPreset(
            id: UUID(uuidString: "00000000-0000-4000-8000-000000000008")!,
            name: "外飲み",
            category: .outside,
            location: .outside,
            defaultPriceYen: 3_000,
            volumeML: 0,
            abvTenthsPercent: 0,
            iconName: "yensign.circle.fill",
            colorName: "outside",
            sortIndex: 7
        )
    ]

    func seedDefaultPresetsIfNeeded(now: Date = .now) throws {
        let descriptor = FetchDescriptor<DrinkPreset>(
            predicate: #Predicate<DrinkPreset> { preset in
                preset.isDefault == true
            }
        )
        let existingDefaultIDs = Set(try context.fetch(descriptor).map(\.id))
        var inserted = false

        for definition in Self.defaultPresets where !existingDefaultIDs.contains(definition.id) {
            context.insert(definition.makePreset(now: now))
            inserted = true
        }

        if inserted {
            try context.save()
        }
    }

    func fetchActivePresets() throws -> [DrinkPreset] {
        let descriptor = FetchDescriptor<DrinkPreset>(
            predicate: #Predicate<DrinkPreset> { preset in
                preset.isArchived == false
            }
        )
        var presets = try context.fetch(descriptor)
        presets.sort(by: Self.preferredPresetOrder)
        return presets
    }

    func incrementUsage(for preset: DrinkPreset, usedAt: Date = .now) throws {
        preset.usageCount += 1
        preset.lastUsedAt = usedAt
        preset.updatedAt = usedAt
        try context.save()
    }

    private static func preferredPresetOrder(lhs: DrinkPreset, rhs: DrinkPreset) -> Bool {
        if lhs.usageCount != rhs.usageCount {
            return lhs.usageCount > rhs.usageCount
        }

        switch (lhs.lastUsedAt, rhs.lastUsedAt) {
        case let (left?, right?) where left != right:
            return left > right
        case (_?, nil):
            return true
        case (nil, _?):
            return false
        default:
            if lhs.sortIndex != rhs.sortIndex {
                return lhs.sortIndex < rhs.sortIndex
            }
            return lhs.name < rhs.name
        }
    }
}

