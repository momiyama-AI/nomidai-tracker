import SwiftData
import SwiftUI

struct QuickRecordConfirmView: View {
    let preset: DrinkPreset
    @Binding var isPresented: Bool
    var onSaved: () -> Void

    @Environment(\.modelContext) private var modelContext
    @State private var quantity: Int = 1
    @State private var unitPriceText: String = ""
    @State private var occurredAt: Date = .now
    @State private var memo: String = ""
    @State private var showSavedAlert = false

    private var isOutside: Bool { preset.location == .outside }

    private var unitPriceYen: Int {
        QuickRecordInputValidator.parseAmountYen(unitPriceText) ?? 0
    }

    private var totalAmountYen: Int {
        unitPriceYen * quantity
    }

    private var totalPureAlcoholTenthsGram: Int {
        AlcoholCalculator.pureAlcoholTenthsGram(
            volumeML: preset.volumeML * quantity,
            abvTenthsPercent: preset.abvTenthsPercent
        )
    }

    var body: some View {
        Form {
            Section {
                HStack(spacing: 12) {
                    Image(systemName: preset.iconName)
                        .font(.title2)
                        .foregroundStyle(.tint)
                        .frame(width: 36)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(preset.name)
                            .font(.headline)
                        Text(LocalizedStringKey(isOutside ? "quickrecord.location.outside" : "quickrecord.location.home"))
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }

            Section {
                TextField("quickrecord.field.amount", text: $unitPriceText)
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
                    Text(CurrencyFormatter.yenString(totalAmountYen))
                        .font(.body.weight(.semibold).monospacedDigit())
                } label: {
                    Text("quickrecord.field.total")
                }

                LabeledContent {
                    Text(AlcoholCalculator.formattedTenthsGram(totalPureAlcoholTenthsGram))
                        .foregroundStyle(.secondary)
                } label: {
                    Text("quickrecord.field.pureAlcohol")
                }

                if isOutside {
                    Text("quickrecord.field.pureAlcohol.note.outside")
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle(Text("quickrecord.confirm.title"))
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button {
                    save()
                } label: {
                    Text("quickrecord.button.save")
                }
            }
        }
        .onAppear {
            if unitPriceText.isEmpty {
                unitPriceText = String(preset.defaultPriceYen)
            }
        }
        .alert(Text("quickrecord.saved.title"), isPresented: $showSavedAlert) {
            Button {
                isPresented = false
            } label: {
                Text("common.ok")
            }
        }
    }

    private func save() {
        let safeQuantity = QuickRecordInputValidator.clampedQuantity(quantity)
        let safeAmount = QuickRecordInputValidator.clampedAmountYen(totalAmountYen)

        do {
            let entryRepository = DrinkEntryRepository(context: modelContext)
            try entryRepository.createEntry(
                from: preset,
                quantity: safeQuantity,
                amountYen: safeAmount,
                occurredAt: occurredAt,
                memo: memo
            )

            let presetRepository = DrinkPresetRepository(context: modelContext)
            try presetRepository.incrementUsage(for: preset, usedAt: occurredAt)

            onSaved()
            showSavedAlert = true
        } catch {
            assertionFailure("記録の保存に失敗しました: \(error)")
        }
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    let presetRepository = DrinkPresetRepository(context: container.mainContext)
    try! presetRepository.seedDefaultPresetsIfNeeded()
    let preset = try! presetRepository.fetchActivePresets()[0]

    return NavigationStack {
        QuickRecordConfirmView(preset: preset, isPresented: .constant(true), onSaved: {})
    }
    .modelContainer(container)
}
