import SwiftData
import SwiftUI

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var settings: UserSettings?
    @State private var baselineText: String = ""
    @State private var isBudgetEnabled: Bool = false
    @State private var budgetText: String = ""

    var body: some View {
        Form {
            Section {
                TextField("settings.baseline.field", text: $baselineText)
                    .keyboardType(.numberPad)
                    .onChange(of: baselineText) { _, _ in saveBaseline() }
            } header: {
                Text("settings.baseline.header")
            } footer: {
                Text("settings.baseline.source")
            }

            Section {
                Toggle("settings.budget.enabled", isOn: $isBudgetEnabled)
                    .onChange(of: isBudgetEnabled) { _, _ in saveBudget() }

                if isBudgetEnabled {
                    TextField("settings.budget.field", text: $budgetText)
                        .keyboardType(.numberPad)
                        .onChange(of: budgetText) { _, _ in saveBudget() }
                }
            } header: {
                Text("settings.budget.header")
            }

            Section {
                NavigationLink {
                    PresetEditListView()
                } label: {
                    Text("settings.presets.link")
                }
            }

            Section {
                Text("settings.notice.moderateDrinking")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            } header: {
                Text("settings.notice.header")
            }
        }
        .navigationTitle(Text("settings.title"))
        .onAppear(perform: reload)
    }

    private func reload() {
        do {
            let repository = SettingsRepository(context: modelContext)
            let loaded = try repository.fetchOrCreateSettings()
            settings = loaded
            baselineText = String(loaded.baselineMonthlyYen)
            if let budget = loaded.monthlyBudgetYen {
                isBudgetEnabled = true
                budgetText = String(budget)
            } else {
                isBudgetEnabled = false
                budgetText = ""
            }
        } catch {
            assertionFailure("設定の取得に失敗しました: \(error)")
        }
    }

    private func saveBaseline() {
        guard let settings else { return }
        guard let value = QuickRecordInputValidator.parseAmountYen(baselineText) else { return }
        do {
            try SettingsRepository(context: modelContext).setBaselineMonthlyYen(max(0, value), for: settings)
            try WidgetSnapshotRefresher(context: modelContext).refresh()
        } catch {
            assertionFailure("基準値の保存に失敗しました: \(error)")
        }
    }

    private func saveBudget() {
        guard let settings else { return }
        do {
            if isBudgetEnabled {
                guard let value = QuickRecordInputValidator.parseAmountYen(budgetText) else { return }
                try SettingsRepository(context: modelContext).setMonthlyBudgetYen(max(0, value), for: settings)
            } else {
                try SettingsRepository(context: modelContext).setMonthlyBudgetYen(nil, for: settings)
            }
            try WidgetSnapshotRefresher(context: modelContext).refresh()
        } catch {
            assertionFailure("予算の保存に失敗しました: \(error)")
        }
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    let context = container.mainContext
    try? DrinkPresetRepository(context: context).seedDefaultPresetsIfNeeded()
    _ = try? SettingsRepository(context: context).fetchOrCreateSettings()

    return NavigationStack {
        SettingsView()
    }
    .modelContainer(container)
}
