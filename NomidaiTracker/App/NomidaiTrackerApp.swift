import SwiftData
import SwiftUI

@main
struct NomidaiTrackerApp: App {
    private let modelContainer = AppEnvironment.liveModelContainer()

    var body: some Scene {
        WindowGroup {
            HomePlaceholderView()
                .task {
                    await AppEnvironment.bootstrapIfNeeded(in: modelContainer)
                }
        }
        .modelContainer(modelContainer)
    }
}

