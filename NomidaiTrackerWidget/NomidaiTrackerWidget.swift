import SwiftUI
import WidgetKit

private struct NomidaiWidgetEntry: TimelineEntry {
    let date: Date
    let snapshot: WidgetSnapshot
}

private struct NomidaiWidgetProvider: TimelineProvider {
    private let store = WidgetSnapshotStore()

    func placeholder(in context: Context) -> NomidaiWidgetEntry {
        NomidaiWidgetEntry(date: .now, snapshot: .empty)
    }

    func getSnapshot(in context: Context, completion: @escaping (NomidaiWidgetEntry) -> Void) {
        completion(NomidaiWidgetEntry(date: .now, snapshot: store.load() ?? .empty))
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<NomidaiWidgetEntry>) -> Void) {
        let now = Date()
        let entry = NomidaiWidgetEntry(date: now, snapshot: store.load() ?? .empty)
        let nextRefresh = Calendar.current.date(byAdding: .minute, value: 15, to: now) ?? now
        completion(Timeline(entries: [entry], policy: .after(nextRefresh)))
    }
}

@main
struct NomidaiTrackerWidget: Widget {
    private let kind = "NomidaiTrackerWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: NomidaiWidgetProvider()) { entry in
            NomidaiWidgetEntryView(entry: entry)
        }
        .configurationDisplayName(LocalizedStringResource("widget.configuration.name"))
        .description(LocalizedStringResource("widget.configuration.description"))
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

private struct NomidaiWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family

    let entry: NomidaiWidgetEntry

    var body: some View {
        Group {
            switch family {
            case .systemMedium:
                mediumContent
            default:
                smallContent
            }
        }
        .containerBackground(.black, for: .widget)
    }

    private var smallContent: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("widget.month.label")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Spacer()
                Text(presentation.emoji)
                    .font(.title2)
            }

            Text(yenString(entry.snapshot.totalAmountYen))
                .font(.system(size: 26, weight: .heavy, design: .rounded))
                .monospacedDigit()
                .minimumScaleFactor(0.72)

            Text(presentation.title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(presentation.color)
                .lineLimit(1)
        }
        .padding()
    }

    private var mediumContent: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 8) {
                Text("widget.month.label")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(yenString(entry.snapshot.totalAmountYen))
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.72)

                if entry.snapshot.isMediumWidgetUnlocked {
                    HStack(spacing: 12) {
                        metric(titleKey: "widget.budget.remaining", value: remainingBudgetText)
                        metric(titleKey: "widget.drydays", value: "\(entry.snapshot.dryDayCount)日")
                    }
                } else {
                    Label {
                        Text("widget.pro.locked")
                            .lineLimit(1)
                    } icon: {
                        Image(systemName: "lock.fill")
                    }
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                }
            }

            Spacer(minLength: 0)

            VStack(spacing: 4) {
                Text(presentation.emoji)
                    .font(.system(size: 46))
                Text(presentation.title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(presentation.color)
                    .lineLimit(1)
            }
            .frame(width: 72)
        }
        .padding()
    }

    private var presentation: WidgetWealthPresentation {
        WidgetWealthPresentation(rawValue: entry.snapshot.wealthLevelRawValue)
    }

    private var remainingBudgetText: String {
        guard let remaining = entry.snapshot.remainingBudgetYen else {
            return NSLocalizedString("home.budget.notSet", comment: "")
        }
        return yenString(remaining)
    }

    private func metric(titleKey: LocalizedStringKey, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(titleKey)
                .font(.caption2)
                .foregroundStyle(.secondary)
            Text(value)
                .font(.caption.weight(.semibold))
                .monospacedDigit()
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
    }

    private func yenString(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        let formatted = formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
        return "\(formatted)円"
    }
}

private struct WidgetWealthPresentation {
    let emoji: String
    let title: String
    let color: Color

    init(rawValue: String) {
        switch rawValue {
        case "grandRich":
            emoji = "👑"
            title = "大富豪"
            color = .yellow
        case "rich":
            emoji = "🎩"
            title = "富豪"
            color = .mint
        case "comfortable":
            emoji = "😊"
            title = "小金持ち"
            color = .green
        case "broke":
            emoji = "💧"
            title = "金欠"
            color = .orange
        case "extremePoor":
            emoji = "📦"
            title = "極貧"
            color = .red
        default:
            emoji = "🍺"
            title = "庶民"
            color = .secondary
        }
    }
}

#Preview(as: .systemSmall) {
    NomidaiTrackerWidget()
} timeline: {
    NomidaiWidgetEntry(
        date: .now,
        snapshot: WidgetSnapshot(
            totalAmountYen: 4_200,
            remainingBudgetYen: 1_300,
            dryDayCount: 7,
            wealthLevelRawValue: "comfortable",
            updatedAt: .now,
            isMediumWidgetUnlocked: true
        )
    )
}

#Preview(as: .systemMedium) {
    NomidaiTrackerWidget()
} timeline: {
    NomidaiWidgetEntry(
        date: .now,
        snapshot: WidgetSnapshot(
            totalAmountYen: 8_900,
            remainingBudgetYen: -900,
            dryDayCount: 3,
            wealthLevelRawValue: "broke",
            updatedAt: .now,
            isMediumWidgetUnlocked: false
        )
    )
}
