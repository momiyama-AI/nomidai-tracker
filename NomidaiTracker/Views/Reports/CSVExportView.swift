import SwiftData
import SwiftUI

struct CSVExportView: View {
    var body: some View {
        PremiumGateView(featureTitleKey: "reports.csv.title") {
            CSVExportContentView()
        }
        .navigationTitle(Text("reports.csv.title"))
    }
}

private struct CSVExportContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var csvText = ""

    var body: some View {
        VStack(spacing: 12) {
            TextEditor(text: $csvText)
                .font(.system(.footnote, design: .monospaced))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .border(.secondary.opacity(0.25))

            ShareLink(item: csvText) {
                Label("reports.csv.share", systemImage: "square.and.arrow.up")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .disabled(csvText.isEmpty)
        }
        .padding()
        .onAppear(perform: load)
    }

    private func load() {
        let entries = (try? DrinkEntryRepository(context: modelContext).fetchAllEntries()) ?? []
        csvText = CSVExporter().export(entries: entries)
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    return NavigationStack {
        CSVExportView()
    }
    .modelContainer(container)
}
