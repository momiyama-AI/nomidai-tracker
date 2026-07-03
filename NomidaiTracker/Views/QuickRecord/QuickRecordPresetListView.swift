import SwiftData
import SwiftUI

struct QuickRecordPresetListView: View {
    @Binding var isPresented: Bool

    @Environment(\.modelContext) private var modelContext
    @State private var presets: [DrinkPreset] = []

    var body: some View {
        NavigationStack {
            List {
                Section {
                    ForEach(presets, id: \.id) { preset in
                        NavigationLink {
                            QuickRecordConfirmView(
                                preset: preset,
                                isPresented: $isPresented,
                                onSaved: reloadPresets
                            )
                        } label: {
                            QuickRecordPresetRow(preset: preset)
                        }
                    }
                } header: {
                    Text("quickrecord.section.presets")
                }
            }
            .navigationTitle(Text("quickrecord.title"))
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        isPresented = false
                    } label: {
                        Text("common.cancel")
                    }
                }
            }
            .onAppear(perform: reloadPresets)
        }
    }

    private func reloadPresets() {
        presets = (try? DrinkPresetRepository(context: modelContext).fetchActivePresets()) ?? []
    }
}

private struct QuickRecordPresetRow: View {
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
                Text(LocalizedStringKey(preset.location == .outside ? "quickrecord.location.outside" : "quickrecord.location.home"))
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
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    try? DrinkPresetRepository(context: container.mainContext).seedDefaultPresetsIfNeeded()

    return QuickRecordPresetListView(isPresented: .constant(true))
        .modelContainer(container)
}
