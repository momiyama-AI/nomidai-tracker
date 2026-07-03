import Foundation
import SwiftData
import WidgetKit

struct WidgetSnapshot: Codable, Equatable {
    let totalAmountYen: Int
    let remainingBudgetYen: Int?
    let dryDayCount: Int
    let wealthLevelRawValue: String
    let updatedAt: Date
    let isMediumWidgetUnlocked: Bool

    static let empty = WidgetSnapshot(
        totalAmountYen: 0,
        remainingBudgetYen: nil,
        dryDayCount: 0,
        wealthLevelRawValue: WealthLevel.grandRich.rawValue,
        updatedAt: Date(timeIntervalSince1970: 0),
        isMediumWidgetUnlocked: false
    )
}

struct WidgetSnapshotStore {
    static let defaultKey = "widget.snapshot.v1"

    private let userDefaults: UserDefaults?
    private let key: String
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    init(
        userDefaults: UserDefaults? = UserDefaults(suiteName: AppGroup.identifier),
        key: String = Self.defaultKey
    ) {
        self.userDefaults = userDefaults
        self.key = key

        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        self.encoder = encoder

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.decoder = decoder
    }

    func save(_ snapshot: WidgetSnapshot) throws {
        let data = try encoder.encode(snapshot)
        userDefaults?.set(data, forKey: key)
    }

    func load() -> WidgetSnapshot? {
        guard let data = userDefaults?.data(forKey: key) else { return nil }
        return try? decoder.decode(WidgetSnapshot.self, from: data)
    }
}

struct WidgetSnapshotBuilder {
    private let summaryRepository: SummaryRepository
    private let settingsRepository: SettingsRepository
    private let calendar: Calendar

    init(context: ModelContext, calendar: Calendar = .current) {
        self.summaryRepository = SummaryRepository(context: context, calendar: calendar)
        self.settingsRepository = SettingsRepository(context: context)
        self.calendar = calendar
    }

    func build(now: Date = .now, isMediumWidgetUnlocked: Bool = false) throws -> WidgetSnapshot {
        let summary = try summaryRepository.monthlySummary(containing: now)
        let settings = try settingsRepository.fetchOrCreateSettings(now: now)
        let dryDayCount = try summaryRepository.dryDayCount(containing: now, today: now)
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
            isMediumWidgetUnlocked: isMediumWidgetUnlocked
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

    func refresh(now: Date = .now, isMediumWidgetUnlocked: Bool = false) throws {
        let snapshot = try builder.build(now: now, isMediumWidgetUnlocked: isMediumWidgetUnlocked)
        try store.save(snapshot)
        reloadTimelines()
    }
}
