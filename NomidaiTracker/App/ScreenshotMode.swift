import Foundation
import SwiftData
import SwiftUI

#if DEBUG
enum ScreenshotScreen: String {
    case home
    case quickRecord
    case calendar
    case settings
    case paywall
}

enum ScreenshotMode {
    private static let demoDataArgument = "-screenshotDemoData"
    private static let screenArgument = "-screenshotScreen"
    private static let demoMemo = "SCREENSHOT_DEMO_DATA"

    static var isEnabled: Bool {
        ProcessInfo.processInfo.arguments.contains(demoDataArgument)
            || ProcessInfo.processInfo.arguments.contains(screenArgument)
    }

    static var screen: ScreenshotScreen {
        let arguments = ProcessInfo.processInfo.arguments
        guard let index = arguments.firstIndex(of: screenArgument),
              arguments.indices.contains(index + 1),
              let screen = ScreenshotScreen(rawValue: arguments[index + 1])
        else {
            return .home
        }
        return screen
    }

    @MainActor
    static func seedDemoDataIfNeeded(in modelContainer: ModelContainer) {
        guard isEnabled else { return }

        let context = modelContainer.mainContext

        do {
            let entryRepository = DrinkEntryRepository(context: context)
            for entry in try entryRepository.fetchAllEntries() where entry.memo == demoMemo {
                try entryRepository.delete(entry)
            }

            let settingsRepository = SettingsRepository(context: context)
            let settings = try settingsRepository.fetchOrCreateSettings()
            try settingsRepository.setBaselineMonthlyYen(5_500, for: settings)
            try settingsRepository.setMonthlyBudgetYen(12_000, for: settings)

            let presetRepository = DrinkPresetRepository(context: context)
            try presetRepository.seedDefaultPresetsIfNeeded()
            let presets = try presetRepository.fetchActivePresets()
            let byName = Dictionary(uniqueKeysWithValues: presets.map { ($0.name, $0) })

            let now = Date()
            try createDemoEntry(
                repository: entryRepository,
                presetRepository: presetRepository,
                preset: byName["缶ビール350"],
                quantity: 2,
                amountYen: 440,
                occurredAt: dateInCurrentMonth(dayOffset: 0, hour: 19, from: now)
            )
            try createDemoEntry(
                repository: entryRepository,
                presetRepository: presetRepository,
                preset: byName["外飲み"],
                quantity: 1,
                amountYen: 4_200,
                occurredAt: dateInCurrentMonth(dayOffset: 1, hour: 21, from: now)
            )
            try createDemoEntry(
                repository: entryRepository,
                presetRepository: presetRepository,
                preset: byName["ハイボール"],
                quantity: 2,
                amountYen: 420,
                occurredAt: dateInCurrentMonth(dayOffset: 2, hour: 20, from: now)
            )
            try createDemoEntry(
                repository: entryRepository,
                presetRepository: presetRepository,
                preset: byName["ワイングラス"],
                quantity: 1,
                amountYen: 300,
                occurredAt: dateInCurrentMonth(dayOffset: 2, hour: 22, from: now)
            )
            try createDemoEntry(
                repository: entryRepository,
                presetRepository: presetRepository,
                preset: byName["外飲み"],
                quantity: 1,
                amountYen: 2_800,
                occurredAt: dateInPreviousMonth(dayOffset: 0, hour: 20, from: now)
            )

            try WidgetSnapshotRefresher(context: context).refresh()
        } catch {
            assertionFailure("スクリーンショット用データの準備に失敗しました: \(error)")
        }
    }

    private static func createDemoEntry(
        repository: DrinkEntryRepository,
        presetRepository: DrinkPresetRepository,
        preset: DrinkPreset?,
        quantity: Int,
        amountYen: Int,
        occurredAt: Date
    ) throws {
        guard let preset else { return }
        _ = try repository.createEntry(
            from: preset,
            quantity: quantity,
            amountYen: amountYen,
            occurredAt: occurredAt,
            memo: demoMemo
        )
        try presetRepository.incrementUsage(for: preset, usedAt: occurredAt)
    }

    private static func dateInCurrentMonth(dayOffset: Int, hour: Int, from date: Date) -> Date {
        let calendar = Calendar.current
        let start = calendar.dateInterval(of: .month, for: date)?.start ?? calendar.startOfDay(for: date)
        let elapsedDays = max(1, calendar.dateComponents([.day], from: start, to: date).day.map { $0 + 1 } ?? 1)
        let safeOffset = min(max(0, dayOffset), elapsedDays - 1)
        let day = calendar.date(byAdding: .day, value: safeOffset, to: start) ?? start
        return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day) ?? day
    }

    private static func dateInPreviousMonth(dayOffset: Int, hour: Int, from date: Date) -> Date {
        let calendar = Calendar.current
        let currentStart = calendar.dateInterval(of: .month, for: date)?.start ?? calendar.startOfDay(for: date)
        let previousStart = calendar.date(byAdding: .month, value: -1, to: currentStart) ?? currentStart
        let daysInPreviousMonth = calendar.range(of: .day, in: .month, for: previousStart)?.count ?? 30
        let safeOffset = min(max(0, dayOffset), daysInPreviousMonth - 1)
        let day = calendar.date(byAdding: .day, value: safeOffset, to: previousStart) ?? previousStart
        return calendar.date(bySettingHour: hour, minute: 0, second: 0, of: day) ?? day
    }
}

struct ScreenshotRootView: View {
    var body: some View {
        switch ScreenshotMode.screen {
        case .home:
            HomeView()
        case .quickRecord:
            QuickRecordPresetListView(isPresented: .constant(true))
        case .calendar:
            NavigationStack {
                CalendarMonthView()
            }
        case .settings:
            NavigationStack {
                SettingsView()
            }
        case .paywall:
            NavigationStack {
                PaywallView()
            }
        }
    }
}
#endif
