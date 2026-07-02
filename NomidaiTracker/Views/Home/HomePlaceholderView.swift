import SwiftData
import SwiftUI

struct HomePlaceholderView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Image(systemName: "yensign.circle")
                    .font(.system(size: 48, weight: .semibold))
                    .foregroundStyle(.tint)

                Text("app.title")
                    .font(.title2.weight(.semibold))

                Text("home.placeholder.subtitle")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding(24)
            .navigationTitle(Text("app.title"))
        }
    }
}

#Preview {
    HomePlaceholderView()
        .modelContainer(try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true))
}

