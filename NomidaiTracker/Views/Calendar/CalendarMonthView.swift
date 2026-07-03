import SwiftData
import SwiftUI

struct CalendarMonthView: View {
    @Environment(\.modelContext) private var modelContext

    @State private var displayedMonth: Date = .now
    @State private var dailySpendings: [Date: DailySpending] = [:]
    @State private var selectedDay: DaySelection?

    private let calendar = Calendar.current
    private let monthCalculator = MonthCalculator()
    private let weekdaySymbolKeys = (0..<7).map { "calendar.weekday.\($0)" }

    private var isCurrentMonth: Bool {
        calendar.isDate(displayedMonth, equalTo: .now, toGranularity: .month)
    }

    private var maxAmountYen: Int {
        dailySpendings.values.map(\.totalAmountYen).max() ?? 0
    }

    var body: some View {
        VStack(spacing: 16) {
            monthHeader
            weekdayHeader
            dayGrid
            Spacer()
        }
        .padding(20)
        .navigationTitle(Text("calendar.title"))
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: reload)
        .onChange(of: displayedMonth) { _, _ in reload() }
        .sheet(item: $selectedDay, onDismiss: reload) { selection in
            NavigationStack {
                DayEntriesListView(date: selection.date, onChanged: reload)
            }
        }
    }

    private var monthHeader: some View {
        HStack {
            Button {
                changeMonth(by: -1)
            } label: {
                Image(systemName: "chevron.left")
            }

            Spacer()

            Text(monthTitle)
                .font(.headline)

            Spacer()

            Button {
                changeMonth(by: 1)
            } label: {
                Image(systemName: "chevron.right")
            }
            .disabled(isCurrentMonth)
        }
    }

    private var weekdayHeader: some View {
        HStack {
            ForEach(0..<7, id: \.self) { index in
                Text(NSLocalizedString(weekdaySymbolKeys[index], comment: ""))
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    private var dayGrid: some View {
        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 7), spacing: 6) {
            ForEach(Array(monthDates.enumerated()), id: \.offset) { _, date in
                if let date {
                    let dayStart = calendar.startOfDay(for: date)
                    let isFuture = dayStart > calendar.startOfDay(for: .now)
                    DayCellView(
                        day: calendar.component(.day, from: date),
                        amountYen: dailySpendings[dayStart]?.totalAmountYen ?? 0,
                        maxAmountYen: maxAmountYen,
                        isFuture: isFuture,
                        isToday: calendar.isDateInToday(date)
                    )
                    .onTapGesture {
                        guard !isFuture else { return }
                        selectedDay = DaySelection(date: dayStart)
                    }
                } else {
                    Color.clear
                }
            }
        }
    }

    private var monthDates: [Date?] {
        let start = monthCalculator.startOfMonth(containing: displayedMonth)
        let daysCount = monthCalculator.daysInMonth(containing: displayedMonth)
        let weekday = calendar.component(.weekday, from: start)
        let leadingBlanks = weekday - 1
        var dates: [Date?] = Array(repeating: nil, count: leadingBlanks)
        for offset in 0..<daysCount {
            dates.append(calendar.date(byAdding: .day, value: offset, to: start))
        }
        return dates
    }

    private var monthTitle: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja_JP")
        formatter.dateFormat = "y年M月"
        return formatter.string(from: displayedMonth)
    }

    private func changeMonth(by value: Int) {
        guard let newMonth = calendar.date(byAdding: .month, value: value, to: displayedMonth) else { return }
        if newMonth > .now && !calendar.isDate(newMonth, equalTo: .now, toGranularity: .month) { return }
        displayedMonth = newMonth
    }

    private func reload() {
        do {
            let summaryRepository = SummaryRepository(context: modelContext)
            let spendings = try summaryRepository.dailySpendings(containing: displayedMonth)
            dailySpendings = Dictionary(uniqueKeysWithValues: spendings.map { ($0.date, $0) })
        } catch {
            assertionFailure("カレンダーデータの取得に失敗しました: \(error)")
        }
    }
}

private struct DaySelection: Identifiable {
    let date: Date
    var id: Date { date }
}

private struct DayCellView: View {
    let day: Int
    let amountYen: Int
    let maxAmountYen: Int
    let isFuture: Bool
    let isToday: Bool

    var body: some View {
        Text("\(day)")
            .font(.caption.weight(isToday ? .bold : .regular))
            .frame(maxWidth: .infinity, minHeight: 36)
            .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isToday ? Color.accentColor : .clear, lineWidth: 1.5)
            )
            .opacity(isFuture ? 0.35 : 1.0)
    }

    private var backgroundColor: Color {
        guard !isFuture else { return Color(.systemGray6) }
        guard amountYen > 0 else { return Color.green.opacity(0.12) }
        let intensity = HeatmapIntensity.level(amountYen: amountYen, maxAmountYen: maxAmountYen)
        return Color.orange.opacity(0.18 + intensity * 0.6)
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    let context = container.mainContext
    let presetRepository = DrinkPresetRepository(context: context)
    try? presetRepository.seedDefaultPresetsIfNeeded()
    if let preset = try? presetRepository.fetchActivePresets().first {
        _ = try? DrinkEntryRepository(context: context).createEntry(from: preset, quantity: 1, amountYen: 220)
    }

    return NavigationStack {
        CalendarMonthView()
    }
    .modelContainer(container)
}
