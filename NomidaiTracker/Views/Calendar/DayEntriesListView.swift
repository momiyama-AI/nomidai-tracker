import SwiftData
import SwiftUI

struct DayEntriesListView: View {
    let date: Date

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var entries: [DrinkEntry] = []

    var body: some View {
        List {
            if entries.isEmpty {
                Text("calendar.day.detail.empty")
                    .foregroundStyle(.secondary)
            } else {
                ForEach(entries, id: \.id) { entry in
                    HStack {
                        VStack(alignment: .leading, spacing: 2) {
                            Text(entry.presetNameSnapshot)
                                .font(.body.weight(.medium))
                            Text(entry.occurredAt, format: .dateTime.hour().minute())
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }

                        Spacer()

                        Text(CurrencyFormatter.yenString(entry.amountYen))
                            .font(.callout.monospacedDigit())
                    }
                }
            }
        }
        .navigationTitle(Text(dayTitle))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("common.close")
                }
            }
        }
        .onAppear(perform: reload)
    }

    private var dayTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "M月d日"
        return formatter.string(from: date)
    }

    private func reload() {
        entries = (try? DrinkEntryRepository(context: modelContext).fetchEntries(on: date)) ?? []
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    let context = container.mainContext
    let presetRepository = DrinkPresetRepository(context: context)
    try? presetRepository.seedDefaultPresetsIfNeeded()
    if let preset = try? presetRepository.fetchActivePresets().first {
        _ = try? DrinkEntryRepository(context: context).createEntry(from: preset, quantity: 1, amountYen: 220)
    }

    return NavigationStack {
        DayEntriesListView(date: .now)
    }
    .modelContainer(container)
}
