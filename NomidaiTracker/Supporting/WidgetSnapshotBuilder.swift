import Foundation
import SwiftData
import WidgetKit

struct WidgetSnapshotBuilder {
    private let summaryRepository: SummaryRepository
    private let settingsRepository: SettingsRepository
    private let purchaseRepository: PurchaseEntitlementRepository
    private let calendar: Calendar

    init(context: ModelContext, calendar: Calendar = .current) {
        self.summaryRepository = SummaryRepository(context: context, calendar: calendar)
        self.settingsRepository = SettingsRepository(context: context)
        self.purchaseRepository = PurchaseEntitlementRepository(context: context)
        self.calendar = calendar
    }

    func build(now: Date = .now, isMediumWidgetUnlocked: Bool? = nil) throws -> WidgetSnapshot {
        let summary = try summaryRepository.monthlySummary(containing: now)
        let settings = try settingsRepository.fetchOrCreateSettings(now: now)
        let dryDayCount = try summaryRepository.dryDayCount(containing: now, today: now)
        let proUnlocked = try isMediumWidgetUnlocked ?? purchaseRepository.isProUnlocked(now: now)
        let wealthLevel = CharacterEngine.wealthLevel(
            monthlySpendingYen: summary.totalAmountYen,
            baselineMonthlyYen: settings.baselineMonthlyYen,
            on: now,
            monthCalculator: MonthCalculator(calendar: calendar)
        )
        let remainingBudgetYen = settings.monthlyBudgetYen.map { $0 - summary.totalAmountYen }

        return WidgetSnapshot(
            totalAmountYen: summary.totalAmountYen,
            remainingBudgetYen: remainingBudgetYen,
            dryDayCount: dryDayCount,
            wealthLevelRawValue: wealthLevel.rawValue,
            updatedAt: now,
            isMediumWidgetUnlocked: proUnlocked
        )
    }
}

struct WidgetSnapshotRefresher {
    private let builder: WidgetSnapshotBuilder
    private let store: WidgetSnapshotStore
    private let reloadTimelines: () -> Void

    init(
        context: ModelContext,
        calendar: Calendar = .current,
        store: WidgetSnapshotStore = WidgetSnapshotStore(),
        reloadTimelines: @escaping () -> Void = { WidgetCenter.shared.reloadAllTimelines() }
    ) {
        self.builder = WidgetSnapshotBuilder(context: context, calendar: calendar)
        self.store = store
        self.reloadTimelines = reloadTimelines
    }

    func refresh(now: Date = .now, isMediumWidgetUnlocked: Bool? = nil) throws {
        let snapshot = try builder.build(now: now, isMediumWidgetUnlocked: isMediumWidgetUnlocked)
        try store.save(snapshot)
        reloadTimelines()
    }
}
