import SwiftData
import SwiftUI

@main
struct NomidaiTrackerApp: App {
    private let modelContainer = AppEnvironment.liveModelContainer()

    var body: some Scene {
        WindowGroup {
            rootView
                .task {
                    AppEnvironment.bootstrapIfNeeded(in: modelContainer)
                    #if DEBUG
                    ScreenshotMode.seedDemoDataIfNeeded(in: modelContainer)
                    #endif
                    try? WidgetSnapshotRefresher(context: modelContainer.mainContext).refresh()
                }
        }
        .modelContainer(modelContainer)
    }

    @ViewBuilder
    private var rootView: some View {
        #if DEBUG
        if ScreenshotMode.isEnabled {
            ScreenshotRootView()
        } else {
            HomeView()
        }
        #else
        HomeView()
        #endif
    }
}
