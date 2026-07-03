import SwiftData
import SwiftUI

struct PresetEditListView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var presets: [DrinkPreset] = []
    @State private var customPresetCount = 0
    @State private var isProUnlocked = false
    @State private var isShowingCreate = false
    @State private var isShowingPaywall = false

    private var remainingFreeSlots: Int {
        max(0, DrinkPresetRepository.freeCustomPresetLimit - customPresetCount)
    }

    var body: some View {
        List {
            Section {
                Button {
                    addCustomPreset()
                } label: {
                    Label("preset.custom.add", systemImage: "plus.circle.fill")
                }

                HStack {
                    Text("preset.custom.status")
                    Spacer()
                    Text(statusText)
                        .foregroundStyle(.secondary)
                }
            } footer: {
                Text(isProUnlocked ? "preset.custom.pro.note" : "preset.custom.free.note")
            }

            Section {
                ForEach(presets, id: \.id) { preset in
                    NavigationLink {
                        PresetEditView(preset: preset, onSaved: reloadPresets)
                    } label: {
                        PresetEditRow(preset: preset)
                    }
                    .swipeActions {
                        if preset.isDefault == false {
                            Button(role: .destructive) {
                                archive(preset)
                            } label: {
                                Label("common.delete", systemImage: "trash")
                            }
                        }
                    }
                }
            }
        }
        .navigationTitle(Text("settings.presets.title"))
        .navigationDestination(isPresented: $isShowingCreate) {
            PresetCreateView(isProUnlocked: isProUnlocked, onSaved: reloadPresets)
        }
        .sheet(isPresented: $isShowingPaywall) {
            NavigationStack {
                PaywallView(featureTitleKey: "preset.custom.pro.feature", onAccessChanged: reloadPresets)
            }
        }
        .onAppear(perform: reloadPresets)
    }

    private var statusText: String {
        if isProUnlocked {
            return NSLocalizedString("preset.custom.status.unlimited", comment: "")
        }
        return String(
            format: NSLocalizedString("preset.custom.status.free", comment: ""),
            customPresetCount,
            DrinkPresetRepository.freeCustomPresetLimit,
            remainingFreeSlots
        )
    }

    private func addCustomPreset() {
        do {
            if try DrinkPresetRepository(context: modelContext).canCreateCustomPreset(isProUnlocked: isProUnlocked) {
                isShowingCreate = true
            } else {
                isShowingPaywall = true
            }
        } catch {
            assertionFailure("カスタムプリセットの追加可否確認に失敗しました: \(error)")
        }
    }

    private func archive(_ preset: DrinkPreset) {
        do {
            try DrinkPresetRepository(context: modelContext).archiveCustomPreset(preset)
            reloadPresets()
        } catch {
            assertionFailure("カスタムプリセットの削除に失敗しました: \(error)")
        }
    }

    private func reloadPresets() {
        do {
            let presetRepository = DrinkPresetRepository(context: modelContext)
            presets = try presetRepository.fetchActivePresets()
            customPresetCount = try presetRepository.countActiveCustomPresets()
            isProUnlocked = (try? PurchaseEntitlementRepository(context: modelContext).isProUnlocked()) ?? false
        } catch {
            assertionFailure("プリセットの取得に失敗しました: \(error)")
        }
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
                HStack(spacing: 6) {
                    Text(preset.name)
                        .font(.body.weight(.medium))
                    if preset.isDefault == false {
                        Text("preset.custom.badge")
                            .font(.caption2.weight(.semibold))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(.thinMaterial, in: Capsule())
                    }
                }
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

private struct PresetCreateView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    let isProUnlocked: Bool
    var onSaved: () -> Void

    @State private var nameText = ""
    @State private var location: DrinkLocation = .home
    @State private var category: DrinkCategory = .custom
    @State private var priceText = ""
    @State private var volumeText = ""
    @State private var abvText = ""
    @State private var isShowingPaywall = false
    @State private var errorKey: LocalizedStringKey?
    @State private var isShowingError = false

    private let homeCategories: [DrinkCategory] = [.beer, .chuhai, .highball, .sake, .wine, .custom]

    var body: some View {
        Form {
            Section {
                TextField("preset.create.field.name", text: $nameText)
            } header: {
                Text("preset.create.field.name")
            }

            Section {
                Picker("preset.create.field.location", selection: $location) {
                    ForEach(DrinkLocation.allCases) { location in
                        Text(locationTitle(for: location)).tag(location)
                    }
                }

                if location == .home {
                    Picker("preset.create.field.category", selection: $category) {
                        ForEach(homeCategories) { category in
                            Text(LocalizedStringKey("drink.category.\(category.rawValue)")).tag(category)
                        }
                    }
                }
            }

            Section {
                TextField("preset.edit.field.price", text: $priceText)
                    .keyboardType(.numberPad)
            } header: {
                Text("preset.edit.field.price")
            }

            if location == .outside {
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
        .navigationTitle(Text("preset.create.title"))
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
        .sheet(isPresented: $isShowingPaywall) {
            NavigationStack {
                PaywallView(featureTitleKey: "preset.custom.pro.feature")
            }
        }
        .alert(Text("preset.create.error.title"), isPresented: $isShowingError) {
            Button("common.ok", role: .cancel) {}
        } message: {
            if let errorKey {
                Text(errorKey)
            }
        }
    }

    private func locationTitle(for location: DrinkLocation) -> LocalizedStringKey {
        location == .outside ? "quickrecord.location.outside" : "quickrecord.location.home"
    }

    private func save() {
        let trimmedName = nameText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard trimmedName.isEmpty == false else {
            showError("preset.create.error.nameRequired")
            return
        }

        let priceYen = PresetEditValidator.clampedPriceYen(
            PresetEditValidator.parsePriceYen(priceText) ?? 0
        )
        let volumeML = location == .outside
            ? 0
            : PresetEditValidator.clampedVolumeML(PresetEditValidator.parseVolumeML(volumeText) ?? 0)
        let abvTenthsPercent = location == .outside
            ? 0
            : PresetEditValidator.clampedAbvTenthsPercent(PresetEditValidator.parseAbvTenthsPercent(abvText) ?? 0)

        do {
            _ = try DrinkPresetRepository(context: modelContext).createCustomPreset(
                name: trimmedName,
                category: location == .outside ? .outside : category,
                location: location,
                defaultPriceYen: priceYen,
                volumeML: volumeML,
                abvTenthsPercent: abvTenthsPercent,
                isProUnlocked: isProUnlocked
            )
            onSaved()
            dismiss()
        } catch DrinkPresetRepositoryError.customPresetLimitReached {
            isShowingPaywall = true
        } catch {
            showError("preset.create.error.saveFailed")
        }
    }

    private func showError(_ key: LocalizedStringKey) {
        errorKey = key
        isShowingError = true
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
