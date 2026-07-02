import Foundation
import SwiftData

@Model
final class UserSettings {
    @Attribute(.unique) var id: UUID
    var baselineMonthlyYen: Int
    var monthlyBudgetYen: Int?
    var hasSeenOnboarding: Bool
    var selectedThemeRawValue: String
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        baselineMonthlyYen: Int = 5_500,
        monthlyBudgetYen: Int? = nil,
        hasSeenOnboarding: Bool = false,
        selectedTheme: AppTheme = .system,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.baselineMonthlyYen = baselineMonthlyYen
        self.monthlyBudgetYen = monthlyBudgetYen
        self.hasSeenOnboarding = hasSeenOnboarding
        self.selectedThemeRawValue = selectedTheme.rawValue
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }

    var selectedTheme: AppTheme {
        get { AppTheme(rawValue: selectedThemeRawValue) ?? .system }
        set { selectedThemeRawValue = newValue.rawValue }
    }
}

