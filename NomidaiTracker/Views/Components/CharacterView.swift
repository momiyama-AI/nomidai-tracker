import SwiftUI
import UIKit

struct CharacterAppearance {
    let badgeSymbolName: String
    let tintColor: Color
    let assetName: String
    let roomColors: [Color]
    let floorColor: Color
    let outfitColor: Color
    let propSymbolName: String
    let propColor: Color
}

extension WealthLevel {
    var appearance: CharacterAppearance {
        switch self {
        case .grandRich:
            return CharacterAppearance(
                badgeSymbolName: "crown.fill",
                tintColor: .yellow,
                assetName: "character_grandRich",
                roomColors: [
                    Color(red: 0.23, green: 0.16, blue: 0.42),
                    Color(red: 0.72, green: 0.47, blue: 0.14)
                ],
                floorColor: Color(red: 0.40, green: 0.25, blue: 0.08),
                outfitColor: Color(red: 0.95, green: 0.76, blue: 0.22),
                propSymbolName: "yensign.circle.fill",
                propColor: .yellow
            )
        case .rich:
            return CharacterAppearance(
                badgeSymbolName: "wineglass.fill",
                tintColor: .purple,
                assetName: "character_rich",
                roomColors: [
                    Color(red: 0.20, green: 0.15, blue: 0.36),
                    Color(red: 0.48, green: 0.31, blue: 0.64)
                ],
                floorColor: Color(red: 0.28, green: 0.18, blue: 0.30),
                outfitColor: Color(red: 0.58, green: 0.40, blue: 0.78),
                propSymbolName: "sparkles",
                propColor: .purple
            )
        case .comfortable:
            return CharacterAppearance(
                badgeSymbolName: "face.smiling.fill",
                tintColor: .mint,
                assetName: "character_comfortable",
                roomColors: [
                    Color(red: 0.13, green: 0.33, blue: 0.32),
                    Color(red: 0.22, green: 0.54, blue: 0.43)
                ],
                floorColor: Color(red: 0.18, green: 0.34, blue: 0.28),
                outfitColor: Color(red: 0.30, green: 0.75, blue: 0.66),
                propSymbolName: "fork.knife",
                propColor: .mint
            )
        case .normal:
            return CharacterAppearance(
                badgeSymbolName: "figure.stand",
                tintColor: .blue,
                assetName: "character_normal",
                roomColors: [
                    Color(red: 0.14, green: 0.21, blue: 0.34),
                    Color(red: 0.23, green: 0.35, blue: 0.52)
                ],
                floorColor: Color(red: 0.20, green: 0.25, blue: 0.32),
                outfitColor: Color(red: 0.32, green: 0.50, blue: 0.80),
                propSymbolName: "house.fill",
                propColor: .blue
            )
        case .broke:
            return CharacterAppearance(
                badgeSymbolName: "lightbulb.fill",
                tintColor: .gray,
                assetName: "character_broke",
                roomColors: [
                    Color(red: 0.17, green: 0.17, blue: 0.17),
                    Color(red: 0.32, green: 0.30, blue: 0.25)
                ],
                floorColor: Color(red: 0.22, green: 0.20, blue: 0.17),
                outfitColor: Color(red: 0.45, green: 0.45, blue: 0.42),
                propSymbolName: "lightbulb.fill",
                propColor: .orange
            )
        case .extremePoor:
            return CharacterAppearance(
                badgeSymbolName: "shippingbox.fill",
                tintColor: .brown,
                assetName: "character_extremePoor",
                roomColors: [
                    Color(red: 0.14, green: 0.12, blue: 0.10),
                    Color(red: 0.34, green: 0.23, blue: 0.15)
                ],
                floorColor: Color(red: 0.25, green: 0.17, blue: 0.11),
                outfitColor: Color(red: 0.56, green: 0.36, blue: 0.23),
                propSymbolName: "leaf.fill",
                propColor: .green
            )
        }
    }
}

/// のみだぬきの見た目。v1.0はSwiftUI描画でアニメ調に表現し、
/// `assetName` と同名の画像が Asset Catalog に追加され次第、自動でPNG表示へ切り替わる。
struct CharacterView: View {
    let level: WealthLevel
    let line: String

    @State private var isBreathing = false
    @State private var isBlinking = false
    @State private var isReacting = false
    @State private var idleNudge = false

    private var appearance: CharacterAppearance { level.appearance }

    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                LivingRoomBackdrop(appearance: appearance)

                characterArt
                    .id(level)
                    .frame(width: 150, height: 156)
                    .scaleEffect(isReacting ? 1.12 : (isBreathing ? 1.03 : 0.98), anchor: .bottom)
                    .rotationEffect(.degrees(isReacting ? -4 : (idleNudge ? 2 : -1)))
                    .offset(y: isReacting ? -10 : 8)
                    .transition(.scale(scale: 0.82).combined(with: .opacity))
                    .animation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true), value: isBreathing)
                    .animation(.spring(response: 0.32, dampingFraction: 0.48), value: isReacting)
                    .animation(.easeInOut(duration: 0.8), value: idleNudge)

                reactionSparkles

                Image(systemName: appearance.badgeSymbolName)
                    .font(.system(size: 19, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(appearance.tintColor)
                    .padding(8)
                    .background(.thinMaterial, in: Circle())
                    .overlay(Circle().stroke(appearance.tintColor.opacity(0.35), lineWidth: 1))
                    .offset(x: -12, y: 12)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 238)
            .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .onTapGesture(perform: triggerTapReaction)
            .onAppear {
                isBreathing = true
            }
            .task(id: level) {
                await runBlinkLoop()
            }
            .task(id: level.rawValue) {
                await runNudgeLoop()
            }
            .animation(.spring(response: 0.55, dampingFraction: 0.72), value: level)

            SpeechBubbleView(text: line)
                .id(line)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.25), value: line)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(NSLocalizedString(level.localizationKey, comment: "")))
        .accessibilityValue(Text(line))
    }

    @ViewBuilder
    private var characterArt: some View {
        if let image = assetImage(named: appearance.assetName) {
            image
                .resizable()
                .scaledToFit()
        } else {
            AnimatedTanukiPlaceholder(
                appearance: appearance,
                isBlinking: isBlinking,
                isReacting: isReacting
            )
        }
    }

    @ViewBuilder
    private var reactionSparkles: some View {
        if isReacting {
            ZStack {
                Image(systemName: "sparkles")
                    .font(.title2.weight(.bold))
                    .foregroundStyle(.yellow)
                    .offset(x: -76, y: 36)
                Image(systemName: "heart.fill")
                    .font(.subheadline.weight(.bold))
                    .foregroundStyle(.pink)
                    .offset(x: 56, y: 72)
            }
            .transition(.scale.combined(with: .opacity))
        }
    }

    private func assetImage(named name: String) -> Image? {
        guard UIImage(named: name) != nil else { return nil }
        return Image(name)
    }

    private func triggerTapReaction() {
        isReacting = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.42) {
            isReacting = false
        }
    }

    private func runBlinkLoop() async {
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 2_700_000_000)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.08)) {
                    isBlinking = true
                }
            }
            try? await Task.sleep(nanoseconds: 120_000_000)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.08)) {
                    isBlinking = false
                }
            }
        }
    }

    private func runNudgeLoop() async {
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 5_200_000_000)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.55)) {
                    idleNudge.toggle()
                }
            }
        }
    }
}

private struct LivingRoomBackdrop: View {
    let appearance: CharacterAppearance

    var body: some View {
        ZStack(alignment: .bottom) {
            RoundedRectangle(cornerRadius: 32, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: appearance.roomColors,
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 32, style: .continuous)
                        .stroke(.white.opacity(0.08), lineWidth: 1)
                )

            VStack {
                HStack(alignment: .top) {
                    roomWindow
                    Spacer()
                    propCluster
                }
                .padding(.top, 22)
                .padding(.horizontal, 28)

                Spacer()
            }

            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(appearance.floorColor.opacity(0.92))
                .frame(height: 62)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(.white.opacity(0.08))
                        .frame(height: 1)
                }
        }
        .frame(width: 238, height: 218)
        .shadow(color: appearance.tintColor.opacity(0.18), radius: 18, y: 10)
    }

    private var roomWindow: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white.opacity(0.12))
            .frame(width: 48, height: 38)
            .overlay {
                VStack(spacing: 0) {
                    Rectangle().fill(.white.opacity(0.14)).frame(height: 1)
                    Spacer()
                    Rectangle().fill(.white.opacity(0.14)).frame(height: 1)
                }
                HStack(spacing: 0) {
                    Rectangle().fill(.white.opacity(0.14)).frame(width: 1)
                    Spacer()
                    Rectangle().fill(.white.opacity(0.14)).frame(width: 1)
                }
            }
    }

    private var propCluster: some View {
        Image(systemName: appearance.propSymbolName)
            .font(.system(size: 30, weight: .semibold))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(appearance.propColor)
            .padding(10)
            .background(.black.opacity(0.12), in: Circle())
    }
}

private struct AnimatedTanukiPlaceholder: View {
    let appearance: CharacterAppearance
    let isBlinking: Bool
    let isReacting: Bool

    var body: some View {
        ZStack {
            tail
                .offset(x: 50, y: 22)

            bodyShape
                .offset(y: 38)

            outfit
                .offset(y: 52)

            head
                .offset(y: -18)

            face
                .offset(y: -8)
        }
        .frame(width: 150, height: 156)
    }

    private var tail: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 0.36, green: 0.26, blue: 0.20))
                .frame(width: 42, height: 88)
                .rotationEffect(.degrees(-28))

            ForEach(0..<4, id: \.self) { index in
                Capsule()
                    .fill(index.isMultiple(of: 2) ? Color(red: 0.88, green: 0.82, blue: 0.70) : Color(red: 0.18, green: 0.16, blue: 0.14))
                    .frame(width: 10, height: 45)
                    .rotationEffect(.degrees(62))
                    .offset(x: CGFloat(index * 8 - 12), y: CGFloat(index * 10 - 12))
            }
        }
    }

    private var bodyShape: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.43, green: 0.30, blue: 0.22))
                .frame(width: 94, height: 88)

            Ellipse()
                .fill(Color(red: 0.93, green: 0.82, blue: 0.62))
                .frame(width: 52, height: 56)
                .offset(y: 8)
        }
    }

    private var outfit: some View {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
            .fill(appearance.outfitColor)
            .frame(width: 72, height: 38)
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white.opacity(0.28), lineWidth: 1)
                    .padding(7)
            }
    }

    private var head: some View {
        ZStack {
            HStack(spacing: 48) {
                EarShape()
                    .fill(Color(red: 0.28, green: 0.20, blue: 0.16))
                    .frame(width: 30, height: 32)
                    .rotationEffect(.degrees(-18))
                EarShape()
                    .fill(Color(red: 0.28, green: 0.20, blue: 0.16))
                    .frame(width: 30, height: 32)
                    .rotationEffect(.degrees(18))
                    .scaleEffect(x: -1, y: 1)
            }
            .offset(y: -31)

            Circle()
                .fill(Color(red: 0.49, green: 0.34, blue: 0.24))
                .frame(width: 86, height: 86)

            Ellipse()
                .fill(Color(red: 0.92, green: 0.81, blue: 0.63))
                .frame(width: 66, height: 44)
                .offset(y: 10)
        }
    }

    private var face: some View {
        VStack(spacing: 7) {
            HStack(spacing: 20) {
                eye
                eye
            }

            HStack(spacing: 8) {
                Circle()
                    .fill(Color.pink.opacity(0.34))
                    .frame(width: 10, height: 6)
                Text(isReacting ? "♪" : "⌣")
                    .font(.system(size: isReacting ? 18 : 16, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.18, green: 0.12, blue: 0.10))
                    .offset(y: -2)
                Circle()
                    .fill(Color.pink.opacity(0.34))
                    .frame(width: 10, height: 6)
            }
        }
    }

    private var eye: some View {
        ZStack {
            if isBlinking {
                Capsule()
                    .fill(Color(red: 0.16, green: 0.10, blue: 0.08))
                    .frame(width: 15, height: 3)
            } else {
                Circle()
                    .fill(Color(red: 0.10, green: 0.07, blue: 0.05))
                    .frame(width: isReacting ? 12 : 10, height: isReacting ? 12 : 10)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(.white.opacity(0.82))
                            .frame(width: 4, height: 4)
                            .offset(x: 2, y: 2)
                    }
            }
        }
        .frame(width: 18, height: 14)
    }
}

private struct EarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addQuadCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY),
            control: CGPoint(x: rect.midX, y: rect.maxY * 0.78)
        )
        path.closeSubpath()
        return path
    }
}

private struct SpeechBubbleView: View {
    let text: String

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
                    .shadow(color: .black.opacity(0.12), radius: 10, y: 5)
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
