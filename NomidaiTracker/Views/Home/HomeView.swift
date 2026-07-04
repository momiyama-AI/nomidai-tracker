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

    private var lifestyleEvaluation: LifestyleEvaluation {
        CharacterEngine.lifestyleEvaluation(
            monthlySpendingYen: totalAmountYen,
            baselineMonthlyYen: baselineMonthlyYen,
            monthlyBudgetYen: monthlyBudgetYen,
            dryDayCount: dryDayCount,
            pureAlcoholTenthsGram: pureAlcoholTenthsGram,
            on: .now
        )
    }

    private var wealthLevel: WealthLevel { lifestyleEvaluation.level }

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
            ScrollView(showsIndicators: false) {
                VStack(spacing: 20) {
                    header
                    totalCard
                    characterStage
                    statsGrid
                    actionButtons
                }
                .padding(.horizontal, 16)
                .padding(.top, 52)
                .padding(.bottom, 30)
            }
            .background(Color.black.ignoresSafeArea())
            .toolbar(.hidden, for: .navigationBar)
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
        .preferredColorScheme(.dark)
    }

    private var header: some View {
        HStack(alignment: .top, spacing: 16) {
            Text("app.title")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
                .frame(maxWidth: .infinity, alignment: .leading)

            NavigationLink {
                SettingsView()
            } label: {
                Image(systemName: "gearshape")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 72, height: 72)
                    .background {
                        Circle()
                            .fill(Color.white.opacity(0.10))
                            .overlay(Circle().stroke(.white.opacity(0.10), lineWidth: 1))
                    }
            }
            .buttonStyle(.plain)
            .accessibilityLabel(Text("settings.title"))
        }
        .padding(.top, 8)
    }

    private var totalCard: some View {
        VStack(spacing: 12) {
            Text("home.section.total")
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(Color.white.opacity(0.46))
            Text(CurrencyFormatter.yenString(totalAmountYen))
                .font(.system(size: 64, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.72)
        }
        .frame(maxWidth: .infinity)
        .padding(.top, 18)
        .padding(.bottom, 2)
    }

    private var characterStage: some View {
        CharacterView(level: wealthLevel, line: characterLine)
            .layoutPriority(1)
            .padding(.top, -4)
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
            StatTileView(
                title: "home.breakdown.home",
                value: CurrencyFormatter.yenString(homeAmountYen),
                valueColor: .white,
                iconSystemName: "house.fill",
                iconColor: Color(red: 0.48, green: 0.88, blue: 0.49)
            )
            StatTileView(
                title: "home.breakdown.outside",
                value: CurrencyFormatter.yenString(outsideAmountYen),
                valueColor: .white,
                iconSystemName: "wineglass.fill",
                iconColor: Color(red: 0.75, green: 0.46, blue: 0.95)
            )
            StatTileView(
                title: "home.pureAlcohol.label",
                value: AlcoholCalculator.formattedTenthsGram(pureAlcoholTenthsGram),
                valueColor: .white,
                iconSystemName: "waterbottle.fill",
                iconColor: Color(red: 0.50, green: 0.78, blue: 1.00)
            )
            StatTileView(
                title: "home.dryDays.label",
                value: dryDaysValueText,
                valueColor: .white,
                iconSystemName: "calendar",
                iconColor: Color(red: 1.00, green: 0.58, blue: 0.30)
            )
            StatTileView(
                title: "home.budget.remaining.label",
                value: budgetRemainingText,
                valueColor: .white,
                iconSystemName: "bag.fill",
                iconColor: Color(red: 0.97, green: 0.74, blue: 0.26)
            )
            StatTileView(
                title: "home.budget.pace.label",
                value: budgetPaceText,
                valueColor: .white,
                iconSystemName: "piggybank.fill",
                iconColor: Color(red: 1.00, green: 0.42, blue: 0.58)
            )
        }
        .padding(.top, 2)
    }

    private var dryDaysValueText: String {
        String(format: NSLocalizedString("home.dryDays.value", comment: ""), dryDayCount)
    }

    private var actionButtons: some View {
        Button {
            isPresentingQuickRecord = true
        } label: {
            HStack(spacing: 14) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 30, weight: .bold))
                Text("home.button.record")
                    .font(.system(size: 26, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 78)
            .background {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [
                                Color(red: 0.17, green: 0.76, blue: 0.58),
                                Color(red: 0.24, green: 0.68, blue: 0.49)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
        }
        .buttonStyle(.plain)
        .padding(.top, 12)
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
