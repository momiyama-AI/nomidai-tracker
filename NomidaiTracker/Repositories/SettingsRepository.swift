import Foundation
import SwiftData

struct SettingsRepository {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func fetchOrCreateSettings(now: Date = .now) throws -> UserSettings {
        let descriptor = FetchDescriptor<UserSettings>(
            sortBy: [
                SortDescriptor(\UserSettings.createdAt, order: .forward)
            ]
        )

        if let existing = try context.fetch(descriptor).first {
            return existing
        }

        let settings = UserSettings(createdAt: now, updatedAt: now)
        context.insert(settings)
        try context.save()
        return settings
    }

    func setBaselineMonthlyYen(_ value: Int, for settings: UserSettings, updatedAt: Date = .now) throws {
        settings.baselineMonthlyYen = value
        settings.updatedAt = updatedAt
        try context.save()
    }

    func setMonthlyBudgetYen(_ value: Int?, for settings: UserSettings, updatedAt: Date = .now) throws {
        settings.monthlyBudgetYen = value
        settings.updatedAt = updatedAt
        try context.save()
    }

    func setHasSeenOnboarding(_ value: Bool, for settings: UserSettings, updatedAt: Date = .now) throws {
        settings.hasSeenOnboarding = value
        settings.updatedAt = updatedAt
        try context.save()
    }

    func setSelectedTheme(_ theme: AppTheme, for settings: UserSettings, updatedAt: Date = .now) throws {
        settings.selectedTheme = theme
        settings.updatedAt = updatedAt
        try context.save()
    }
}

