import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var isPresentingQuickRecord = false
    @State private var summary: MonthlySummary?
    @State private var previousMonthTotalYen = 0
    @State private var dryDayCount = 0
    @State private var baselineMonthlyYen = 5_500
    @State private var monthlyBudgetYen: Int?

    private let calendar = Calendar.current

    private var totalAmountYen: Int { summary?.totalAmountYen ?? 0 }
    private var homeAmountYen: Int { summary?.homeAmountYen ?? 0 }
    private var outsideAmountYen: Int { summary?.outsideAmountYen ?? 0 }
    private var pureAlcoholTenthsGram: Int { summary?.pureAlcoholTenthsGram ?? 0 }

    private var wealthLevel: WealthLevel {
        CharacterEngine.wealthLevel(
            monthlySpendingYen: totalAmountYen,
            baselineMonthlyYen: baselineMonthlyYen,
            on: .now
        )
    }

    private var characterLine: String {
        let variant = calendar.component(.day, from: .now) % 2
        let key = CharacterEngine.lineLocalizationKey(for: wealthLevel, variant: variant)
        return NSLocalizedString(key, comment: "")
    }

    private var budgetStatus: BudgetStatus? {
        guard let monthlyBudgetYen else { return nil }
        return BudgetCalculator.status(budgetYen: monthlyBudgetYen, spentYen: totalAmountYen, on: .now)
    }

    private var budgetRemainingText: String {
        guard let budgetStatus else { return NSLocalizedString("home.budget.notSet", comment: "") }
        return CurrencyFormatter.yenString(budgetStatus.remainingYen)
    }

    private var budgetPaceText: String {
        guard let budgetStatus else { return NSLocalizedString("home.budget.notSet", comment: "") }
        let percent = Int((budgetStatus.paceRatio * 100).rounded())
        return String(format: NSLocalizedString("home.budget.pace.value", comment: ""), percent)
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    totalCard
                    CharacterView(level: wealthLevel, line: characterLine)
                    comparisonRow
                    statsGrid
                    actionButtons
                }
                .padding(20)
            }
            .navigationTitle(Text("app.title"))
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink {
                        SettingsView()
                    } label: {
                        Image(systemName: "gearshape")
                    }
                }
            }
            .onAppear(perform: reload)
            .onChange(of: isPresentingQuickRecord) { _, isPresenting in
                if !isPresenting {
                    reload()
                }
            }
            .sheet(isPresented: $isPresentingQuickRecord) {
                QuickRecordPresetListView(isPresented: $isPresentingQuickRecord)
            }
        }
    }

    private var totalCard: some View {
        VStack(spacing: 4) {
            Text("home.section.total")
                .font(.subheadline)
                .foregroundStyle(.secondary)
            Text(CurrencyFormatter.yenString(totalAmountYen))
                .font(.system(size: 48, weight: .heavy, design: .rounded))
                .monospacedDigit()
        }
        .frame(maxWidth: .infinity)
    }

    private var comparisonRow: some View {
        HStack(spacing: 6) {
            Text("home.comparison.label")
                .font(.footnote)
                .foregroundStyle(.secondary)
            Text(comparisonText)
                .font(.footnote.weight(.semibold))
                .foregroundStyle(comparisonColor)
        }
    }

    private var comparisonDifferenceYen: Int { totalAmountYen - previousMonthTotalYen }

    private var comparisonText: String {
        if comparisonDifferenceYen == 0 {
            return NSLocalizedString("home.comparison.same", comment: "")
        }
        let formatKey = comparisonDifferenceYen > 0 ? "home.comparison.increase" : "home.comparison.decrease"
        let format = NSLocalizedString(formatKey, comment: "")
        return String(format: format, CurrencyFormatter.yenString(abs(comparisonDifferenceYen)))
    }

    private var comparisonColor: Color {
        if comparisonDifferenceYen == 0 { return .secondary }
        return comparisonDifferenceYen > 0 ? .red : .green
    }

    private var statsGrid: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            StatTileView(title: "home.breakdown.home", value: CurrencyFormatter.yenString(homeAmountYen))
            StatTileView(title: "home.breakdown.outside", value: CurrencyFormatter.yenString(outsideAmountYen))
            StatTileView(title: "home.pureAlcohol.label", value: AlcoholCalculator.formattedTenthsGram(pureAlcoholTenthsGram))
            StatTileView(title: "home.dryDays.label", value: dryDaysValueText)
            StatTileView(title: "home.budget.remaining.label", value: budgetRemainingText)
            StatTileView(title: "home.budget.pace.label", value: budgetPaceText)
        }
    }

    private var dryDaysValueText: String {
        String(format: NSLocalizedString("home.dryDays.value", comment: ""), dryDayCount)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
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

            NavigationLink {
                CalendarMonthView()
            } label: {
                Label {
                    Text("home.calendar.button")
                } icon: {
                    Image(systemName: "calendar")
                }
                .font(.body.weight(.medium))
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            NavigationLink {
                SpendingChartView()
            } label: {
                Label {
                    Text("home.reports.chart.button")
                } icon: {
                    Image(systemName: "chart.line.uptrend.xyaxis")
                }
                .font(.body.weight(.medium))
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)

            NavigationLink {
                CSVExportView()
            } label: {
                Label {
                    Text("home.reports.csv.button")
                } icon: {
                    Image(systemName: "square.and.arrow.up")
                }
                .font(.body.weight(.medium))
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .controlSize(.large)
        }
    }

    private func reload() {
        do {
            let summaryRepository = SummaryRepository(context: modelContext)
            summary = try summaryRepository.monthlySummary(containing: .now)
            previousMonthTotalYen = try summaryRepository.previousMonthSameElapsedTotalYen(upTo: .now)
            dryDayCount = try summaryRepository.dryDayCount(containing: .now)
            let settings = try SettingsRepository(context: modelContext).fetchOrCreateSettings()
            baselineMonthlyYen = settings.baselineMonthlyYen
            monthlyBudgetYen = settings.monthlyBudgetYen
            try WidgetSnapshotRefresher(context: modelContext).refresh()
        } catch {
            assertionFailure("ホーム画面のデータ取得に失敗しました: \(error)")
        }
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    let context = container.mainContext
    let presetRepository = DrinkPresetRepository(context: context)
    try? presetRepository.seedDefaultPresetsIfNeeded()
    _ = try? SettingsRepository(context: context).fetchOrCreateSettings()
    if let preset = try? presetRepository.fetchActivePresets().first {
        _ = try? DrinkEntryRepository(context: context).createEntry(from: preset, quantity: 2, amountYen: 440)
    }

    return HomeView()
        .modelContainer(container)
}
