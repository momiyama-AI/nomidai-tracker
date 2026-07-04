import SwiftUI

struct StatTileView: View {
    let title: LocalizedStringKey
    let value: String
    var valueColor: Color = .primary
    var iconSystemName: String?
    var iconColor: Color = .accentColor

    var body: some View {
        HStack(spacing: 14) {
            if let iconSystemName {
                Image(systemName: iconSystemName)
                    .font(.system(size: 28, weight: .semibold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(iconColor)
                    .frame(width: 42, height: 42)
            }

            VStack(alignment: .leading, spacing: 7) {
                Text(title)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(Color.white.opacity(0.58))
                    .lineLimit(1)
                    .minimumScaleFactor(0.78)
                Text(value)
                    .font(.system(size: 28, weight: .bold, design: .rounded))
                    .monospacedDigit()
                    .foregroundStyle(valueColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.72)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 96)
        .padding(.horizontal, 18)
        .background {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.105, green: 0.110, blue: 0.125),
                            Color(red: 0.070, green: 0.075, blue: 0.088)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(.white.opacity(0.045), lineWidth: 1)
                }
        }
    }
}

#Preview {
    HStack {
        StatTileView(title: "home.breakdown.home", value: "¥12,000", valueColor: .white, iconSystemName: "house.fill", iconColor: .green)
        StatTileView(title: "home.dryDays.label", value: "5日", valueColor: .white, iconSystemName: "calendar", iconColor: .orange)
    }
    .padding()
    .background(.black)
}
