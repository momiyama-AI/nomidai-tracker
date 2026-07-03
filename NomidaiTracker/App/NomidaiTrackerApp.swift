import SwiftData
import SwiftUI

@main
struct NomidaiTrackerApp: App {
    private let modelContainer = AppEnvironment.liveModelContainer()

    var body: some Scene {
        WindowGroup {
            HomeView()
                .task {
                    AppEnvironment.bootstrapIfNeeded(in: modelContainer)
                    try? WidgetSnapshotRefresher(context: modelContainer.mainContext).refresh()
                }
        }
        .modelContainer(modelContainer)
    }
}
