import SwiftData
import SwiftUI

struct PresetEditView: View {
    let preset: DrinkPreset
    var onSaved: () -> Void

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var priceText: String = ""
    @State private var volumeText: String = ""
    @State private var abvText: String = ""

    private var isOutside: Bool { preset.location == .outside }

    var body: some View {
        Form {
            Section {
                TextField("preset.edit.field.price", text: $priceText)
                    .keyboardType(.numberPad)
            } header: {
                Text("preset.edit.field.price")
            }

            if isOutside {
                Section {
                    Text("preset.edit.outside.note")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            } else {
                Section {
                    TextField("preset.edit.field.volume", text: $volumeText)
                        .keyboardType(.numberPad)
                } header: {
                    Text("preset.edit.field.volume")
                }

                Section {
                    TextField("preset.edit.field.abv", text: $abvText)
                        .keyboardType(.decimalPad)
                } header: {
                    Text("preset.edit.field.abv")
                }
            }
        }
        .navigationTitle(Text(preset.name))
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
        .onAppear(perform: loadFields)
    }

    private func loadFields() {
        priceText = String(preset.defaultPriceYen)
        volumeText = String(preset.volumeML)
        abvText = PresetEditValidator.abvPercentText(fromTenths: preset.abvTenthsPercent)
    }

    private func save() {
        let priceYen = PresetEditValidator.clampedPriceYen(
            PresetEditValidator.parsePriceYen(priceText) ?? preset.defaultPriceYen
        )
        let volumeML = isOutside
            ? preset.volumeML
            : PresetEditValidator.clampedVolumeML(PresetEditValidator.parseVolumeML(volumeText) ?? preset.volumeML)
        let abvTenthsPercent = isOutside
            ? preset.abvTenthsPercent
            : PresetEditValidator.clampedAbvTenthsPercent(PresetEditValidator.parseAbvTenthsPercent(abvText) ?? preset.abvTenthsPercent)

        do {
            try DrinkPresetRepository(context: modelContext).updatePreset(
                preset,
                defaultPriceYen: priceYen,
                volumeML: volumeML,
                abvTenthsPercent: abvTenthsPercent
            )
            onSaved()
            dismiss()
        } catch {
            assertionFailure("プリセットの保存に失敗しました: \(error)")
        }
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    let presetRepository = DrinkPresetRepository(context: container.mainContext)
    try! presetRepository.seedDefaultPresetsIfNeeded()
    let preset = try! presetRepository.fetchActivePresets()[0]

    return NavigationStack {
        PresetEditView(preset: preset, onSaved: {})
    }
    .modelContainer(container)
}
