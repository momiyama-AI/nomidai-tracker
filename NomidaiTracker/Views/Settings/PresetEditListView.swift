import SwiftData
import SwiftUI

struct PresetEditListView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var presets: [DrinkPreset] = []

    var body: some View {
        List {
            ForEach(presets, id: \.id) { preset in
                NavigationLink {
                    PresetEditView(preset: preset, onSaved: reloadPresets)
                } label: {
                    PresetEditRow(preset: preset)
                }
            }
        }
        .navigationTitle(Text("settings.presets.title"))
        .onAppear(perform: reloadPresets)
    }

    private func reloadPresets() {
        presets = (try? DrinkPresetRepository(context: modelContext).fetchActivePresets()) ?? []
    }
}

private struct PresetEditRow: View {
    let preset: DrinkPreset

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: preset.iconName)
                .font(.title3)
                .foregroundStyle(.tint)
                .frame(width: 32)

            VStack(alignment: .leading, spacing: 2) {
                Text(preset.name)
                    .font(.body.weight(.medium))
                Text(detailText)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text(CurrencyFormatter.yenString(preset.defaultPriceYen))
                .font(.callout.monospacedDigit())
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 4)
    }

    private var detailText: String {
        if preset.location == .outside {
            return NSLocalizedString("quickrecord.location.outside", comment: "")
        }
        let abvText = PresetEditValidator.abvPercentText(fromTenths: preset.abvTenthsPercent)
        return "\(preset.volumeML)ml / \(abvText)%"
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    try? DrinkPresetRepository(context: container.mainContext).seedDefaultPresetsIfNeeded()

    return NavigationStack {
        PresetEditListView()
    }
    .modelContainer(container)
}
