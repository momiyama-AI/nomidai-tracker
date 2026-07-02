import SwiftData

enum AppEnvironment {
    static let schema = Schema([
        DrinkPreset.self,
        DrinkEntry.self,
        UserSettings.self,
        PurchaseEntitlement.self
    ])

    static func makeModelContainer(isStoredInMemoryOnly: Bool = false) throws -> ModelContainer {
        let configuration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: isStoredInMemoryOnly
        )

        return try ModelContainer(
            for: schema,
            configurations: [configuration]
        )
    }

    static func liveModelContainer() -> ModelContainer {
        do {
            return try makeModelContainer()
        } catch {
            fatalError("SwiftData container initialization failed: \(error)")
        }
    }

    @MainActor
    static func bootstrapIfNeeded(in modelContainer: ModelContainer) {
        let context = modelContainer.mainContext

        do {
            _ = try SettingsRepository(context: context).fetchOrCreateSettings()
            try DrinkPresetRepository(context: context).seedDefaultPresetsIfNeeded()
        } catch {
            assertionFailure("Initial local data bootstrap failed: \(error)")
        }
    }
}

