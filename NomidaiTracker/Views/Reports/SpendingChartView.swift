import Charts
import SwiftData
import SwiftUI

struct SpendingChartView: View {
    var body: some View {
        PremiumGateView(featureTitleKey: "reports.chart.title") {
            SpendingChartContentView()
        }
        .navigationTitle(Text("reports.chart.title"))
    }
}

private struct SpendingChartContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var points: [MonthlyChartPoint] = []

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Chart(points) { point in
                LineMark(
                    x: .value("reports.chart.month", point.month, unit: .month),
                    y: .value("reports.chart.amount", point.totalAmountYen)
                )
                PointMark(
                    x: .value("reports.chart.month", point.month, unit: .month),
                    y: .value("reports.chart.amount", point.totalAmountYen)
                )
            }
            .frame(minHeight: 260)

            List(points) { point in
                HStack {
                    Text(monthText(point.month))
                    Spacer()
                    Text(CurrencyFormatter.yenString(point.totalAmountYen))
                        .monospacedDigit()
                }
            }
            .listStyle(.plain)
        }
        .padding()
        .onAppear(perform: load)
    }

    private func load() {
        let entries = (try? DrinkEntryRepository(context: modelContext).fetchAllEntries()) ?? []
        points = MonthlyChartPoint.makePoints(entries: entries)
    }

    private func monthText(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年M月"
        return formatter.string(from: date)
    }
}

private struct MonthlyChartPoint: Identifiable {
    let month: Date
    let totalAmountYen: Int

    var id: Date { month }

    static func makePoints(entries: [DrinkEntry], calendar: Calendar = .current) -> [MonthlyChartPoint] {
        let grouped = Dictionary(grouping: entries) { entry in
            let components = calendar.dateComponents([.year, .month], from: entry.occurredAt)
            return calendar.date(from: components) ?? calendar.startOfDay(for: entry.occurredAt)
        }

        return grouped
            .map { month, entries in
                MonthlyChartPoint(
                    month: month,
                    totalAmountYen: entries.reduce(0) { $0 + $1.amountYen }
                )
            }
            .sorted { $0.month < $1.month }
    }
}

#Preview {
    let container = try! AppEnvironment.makeModelContainer(isStoredInMemoryOnly: true)
    return NavigationStack {
        SpendingChartView()
    }
    .modelContainer(container)
}
