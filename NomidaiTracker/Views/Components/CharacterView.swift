import SwiftUI
import UIKit

struct CharacterAppearance {
    let emoji: String
    let badgeSymbolName: String
    let tintColor: Color
    let assetName: String
}

extension WealthLevel {
    var appearance: CharacterAppearance {
        switch self {
        case .grandRich:
            return CharacterAppearance(
                emoji: "🦝",
                badgeSymbolName: "crown.fill",
                tintColor: .yellow,
                assetName: "character_grandRich"
            )
        case .rich:
            return CharacterAppearance(
                emoji: "🦝",
                badgeSymbolName: "wineglass.fill",
                tintColor: .purple,
                assetName: "character_rich"
            )
        case .comfortable:
            return CharacterAppearance(
                emoji: "🦝",
                badgeSymbolName: "face.smiling.fill",
                tintColor: .mint,
                assetName: "character_comfortable"
            )
        case .normal:
            return CharacterAppearance(
                emoji: "🦝",
                badgeSymbolName: "figure.stand",
                tintColor: .blue,
                assetName: "character_normal"
            )
        case .broke:
            return CharacterAppearance(
                emoji: "🦝",
                badgeSymbolName: "lightbulb.fill",
                tintColor: .gray,
                assetName: "character_broke"
            )
        case .extremePoor:
            return CharacterAppearance(
                emoji: "🦝",
                badgeSymbolName: "shippingbox.fill",
                tintColor: .brown,
                assetName: "character_extremePoor"
            )
        }
    }
}

/// のみだぬきの見た目。v1.0はSF Symbols + 絵文字で描画し、
/// `assetName` と同名の画像が Asset Catalog に追加され次第、自動でPNG表示へ切り替わる。
struct CharacterView: View {
    let level: WealthLevel
    let line: String

    @State private var bounce = false

    private var appearance: CharacterAppearance { level.appearance }

    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                Circle()
                    .fill(appearance.tintColor.opacity(0.22))
                    .frame(width: 132, height: 132)

                glyph
                    .id(level)
                    .transition(.scale.combined(with: .opacity))
                    .frame(width: 132, height: 132)

                Image(systemName: appearance.badgeSymbolName)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(appearance.tintColor)
                    .padding(6)
                    .background(.thinMaterial, in: Circle())
                    .offset(x: 4, y: -4)
            }
            .scaleEffect(bounce ? 1.12 : 1.0)
            .animation(.spring(response: 0.45, dampingFraction: 0.55), value: level)
            .animation(.spring(response: 0.3, dampingFraction: 0.4), value: bounce)
            .onChange(of: level) { _, _ in
                triggerBounce()
            }

            SpeechBubbleView(text: line)
                .id(line)
                .transition(.opacity)
                .animation(.easeInOut(duration: 0.25), value: line)
        }
        .accessibilityElement(children: .combine)
    }

    @ViewBuilder
    private var glyph: some View {
        if let image = assetImage(named: appearance.assetName) {
            image
                .resizable()
                .scaledToFit()
        } else {
            Text(appearance.emoji)
                .font(.system(size: 64))
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func assetImage(named name: String) -> Image? {
        guard UIImage(named: name) != nil else { return nil }
        return Image(name)
    }

    private func triggerBounce() {
        bounce = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.22) {
            bounce = false
        }
    }
}

private struct SpeechBubbleView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.medium))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .fixedSize(horizontal: false, vertical: true)
    }
}

#Preview("大富豪") {
    CharacterView(level: .grandRich, line: "今夜はドンペリでも開けるかね")
        .padding()
}

#Preview("極貧") {
    CharacterView(level: .extremePoor, line: "もやし、うまい…")
        .padding()
}
