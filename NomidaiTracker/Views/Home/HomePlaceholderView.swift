import SwiftData
import SwiftUI

struct HomePlaceholderView: View {
    @State private var isPresentingQuickRecord = false

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

                Button {
                    isPresentingQuickRecord = true
                } label: {
                    Label {
                        Text("home.button.record")
                    } icon: {
                        Image(systemName: "plus.circle.fill")
                    }
                    .font(.title3.weight(.semibold))
                    .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .padding(.top, 8)
            }
            .padding(24)
            .navigationTitle(Text("app.title"))
            .sheet(isPresented: $isPresentingQuickRecord) {
                QuickRecordPresetListView(isPresented: $isPresentingQuickRecord)
            }
        }
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    try? DrinkPresetRepository(context: container.mainContext).seedDefaultPresetsIfNeeded()

    return HomePlaceholderView()
        .modelContainer(container)
}

