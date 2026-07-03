import SwiftData
import SwiftUI

struct DayEntriesListView: View {
    let date: Date
    var onChanged: () -> Void = {}

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
                    NavigationLink {
                        EntryEditView(entry: entry) {
                            reload()
                            onChanged()
                        }
                    } label: {
                        DayEntryRow(entry: entry)
                    }
                    .swipeActions {
                        Button(role: .destructive) {
                            delete(entry)
                        } label: {
                            Label("common.delete", systemImage: "trash")
                        }
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

    private func delete(_ entry: DrinkEntry) {
        do {
            try DrinkEntryRepository(context: modelContext).delete(entry)
            try WidgetSnapshotRefresher(context: modelContext).refresh()
            reload()
            onChanged()
        } catch {
            assertionFailure("記録の削除に失敗しました: \(error)")
        }
    }
}

private struct DayEntryRow: View {
    let entry: DrinkEntry

    var body: some View {
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

private struct EntryEditView: View {
    let entry: DrinkEntry
    var onSaved: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var amountText: String = ""
    @State private var quantity: Int = 1
    @State private var occurredAt: Date = .now
    @State private var memo: String = ""

    private var isOutside: Bool { entry.location == .outside }

    private var amountYen: Int {
        QuickRecordInputValidator.parseAmountYen(amountText) ?? 0
    }

    private var pureAlcoholTenthsGram: Int {
        AlcoholCalculator.pureAlcoholTenthsGram(
            volumeML: entry.volumeML * quantity,
            abvTenthsPercent: entry.abvTenthsPercent
        )
    }

    var body: some View {
        Form {
            Section {
                LabeledContent {
                    Text(entry.presetNameSnapshot)
                } label: {
                    Text("entry.edit.drink")
                }

                LabeledContent {
                    Text(LocalizedStringKey(isOutside ? "quickrecord.location.outside" : "quickrecord.location.home"))
                } label: {
                    Text("entry.edit.location")
                }
            }

            Section {
                TextField("quickrecord.field.amount", text: $amountText)
                    .keyboardType(.numberPad)
            } header: {
                Text("quickrecord.field.amount")
            }

            if !isOutside {
                Section {
                    Stepper(value: $quantity, in: 1...99) {
                        Text("\(quantity)")
                            .font(.body.monospacedDigit())
                    }
                } header: {
                    Text("quickrecord.field.quantity")
                }
            }

            Section {
                DatePicker(selection: $occurredAt) {
                    Text("quickrecord.field.date")
                }
            }

            Section {
                TextField("quickrecord.field.memo", text: $memo, axis: .vertical)
                    .lineLimit(1...3)
            } header: {
                Text("quickrecord.field.memo")
            }

            Section {
                LabeledContent {
                    Text(CurrencyFormatter.yenString(amountYen))
                        .font(.body.weight(.semibold).monospacedDigit())
                } label: {
                    Text("quickrecord.field.total")
                }

                LabeledContent {
                    Text(AlcoholCalculator.formattedTenthsGram(pureAlcoholTenthsGram))
                        .foregroundStyle(.secondary)
                } label: {
                    Text("quickrecord.field.pureAlcohol")
                }
            }
        }
        .navigationTitle(Text("entry.edit.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    save()
                } label: {
                    Text("common.save")
                }
            }
        }
        .onAppear(perform: loadEntry)
    }

    private func loadEntry() {
        amountText = String(entry.amountYen)
        quantity = max(1, entry.quantity)
        occurredAt = entry.occurredAt
        memo = entry.memo
    }

    private func save() {
        do {
            try DrinkEntryRepository(context: modelContext).update(
                entry,
                occurredAt: occurredAt,
                quantity: quantity,
                amountYen: QuickRecordInputValidator.clampedAmountYen(amountYen),
                memo: memo
            )
            try WidgetSnapshotRefresher(context: modelContext).refresh()
            onSaved()
            dismiss()
        } catch {
            assertionFailure("記録の更新に失敗しました: \(error)")
        }
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
