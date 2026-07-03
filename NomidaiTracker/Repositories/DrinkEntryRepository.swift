import Foundation
import SwiftData

struct DrinkEntryRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    @discardableResult
    func createEntry(
        from preset: DrinkPreset,
        quantity: Int = 1,
        amountYen: Int? = nil,
        occurredAt: Date = .now,
        memo: String = ""
    ) throws -> DrinkEntry {
        let safeQuantity = max(1, quantity)
        let totalAmountYen = amountYen ?? preset.defaultPriceYen * safeQuantity
        let entry = DrinkEntry(
            occurredAt: occurredAt,
            presetID: preset.id,
            presetNameSnapshot: preset.name,
            category: preset.category,
            location: preset.location,
            quantity: safeQuantity,
            amountYen: totalAmountYen,
            volumeML: preset.volumeML,
            abvTenthsPercent: preset.abvTenthsPercent,
            memo: memo
        )

        context.insert(entry)
        try context.save()
        return entry
    }

    @discardableResult
    func createEntry(
        occurredAt: Date = .now,
        presetID: UUID? = nil,
        presetNameSnapshot: String,
        category: DrinkCategory,
        location: DrinkLocation,
        quantity: Int,
        amountYen: Int,
        volumeML: Int,
        abvTenthsPercent: Int,
        memo: String = ""
    ) throws -> DrinkEntry {
        let entry = DrinkEntry(
            occurredAt: occurredAt,
            presetID: presetID,
            presetNameSnapshot: presetNameSnapshot,
            category: category,
            location: location,
            quantity: quantity,
            amountYen: amountYen,
            volumeML: volumeML,
            abvTenthsPercent: abvTenthsPercent,
            memo: memo
        )

        context.insert(entry)
        try context.save()
        return entry
    }

    func fetchEntries(from startDate: Date, to endDate: Date) throws -> [DrinkEntry] {
        let descriptor = FetchDescriptor<DrinkEntry>(
            predicate: #Predicate<DrinkEntry> { entry in
                entry.occurredAt >= startDate && entry.occurredAt < endDate
            },
            sortBy: [
                SortDescriptor(\DrinkEntry.occurredAt, order: .forward)
            ]
        )

        return try context.fetch(descriptor)
    }

    func fetchEntries(on date: Date, calendar: Calendar = .current) throws -> [DrinkEntry] {
        let start = calendar.startOfDay(for: date)
        let end = calendar.date(byAdding: .day, value: 1, to: start) ?? start
        return try fetchEntries(from: start, to: end)
    }

    func fetchAllEntries() throws -> [DrinkEntry] {
        let descriptor = FetchDescriptor<DrinkEntry>(
            sortBy: [
                SortDescriptor(\DrinkEntry.occurredAt, order: .reverse)
            ]
        )

        return try context.fetch(descriptor)
    }

    func update(
        _ entry: DrinkEntry,
        occurredAt: Date? = nil,
        quantity: Int? = nil,
        amountYen: Int? = nil,
        volumeML: Int? = nil,
        abvTenthsPercent: Int? = nil,
        memo: String? = nil,
        updatedAt: Date = .now
    ) throws {
        if let occurredAt {
            entry.occurredAt = occurredAt
        }
        if let quantity {
            entry.quantity = max(1, quantity)
        }
        if let amountYen {
            entry.amountYen = max(0, amountYen)
        }
        if let volumeML {
            entry.volumeML = max(0, volumeML)
        }
        if let abvTenthsPercent {
            entry.abvTenthsPercent = max(0, abvTenthsPercent)
        }
        if let memo {
            entry.memo = memo
        }

        entry.pureAlcoholTenthsGram = AlcoholCalculator.pureAlcoholTenthsGram(
            volumeML: entry.volumeML * entry.quantity,
            abvTenthsPercent: entry.abvTenthsPercent
        )
        entry.updatedAt = updatedAt
        try context.save()
    }

    func delete(_ entry: DrinkEntry) throws {
        context.delete(entry)
        try context.save()
    }
}

