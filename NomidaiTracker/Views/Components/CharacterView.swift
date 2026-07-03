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
    let headAccessorySymbolName: String?
    let bodyWidthScale: CGFloat
    let bodyHeightScale: CGFloat
    let postureTiltDegrees: Double
    let headYOffset: CGFloat
    let mouthSymbol: String
    let clutterLevel: Int
    let clutterSymbols: [String]
    let idleRotationDegrees: Double
    let breathScale: CGFloat
    let reactionSymbolName: String
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
                    Color(red: 0.18, green: 0.10, blue: 0.32),
                    Color(red: 0.72, green: 0.46, blue: 0.12)
                ],
                floorColor: Color(red: 0.42, green: 0.26, blue: 0.08),
                outfitColor: Color(red: 0.96, green: 0.78, blue: 0.22),
                propSymbolName: "yensign.circle.fill",
                propColor: .yellow,
                headAccessorySymbolName: "crown.fill",
                bodyWidthScale: 1.14,
                bodyHeightScale: 1.02,
                postureTiltDegrees: -3,
                headYOffset: -8,
                mouthSymbol: "▽",
                clutterLevel: 0,
                clutterSymbols: ["sparkles", "yensign.circle.fill", "crown.fill"],
                idleRotationDegrees: 2.6,
                breathScale: 1.045,
                reactionSymbolName: "sparkles"
            )
        case .rich:
            return CharacterAppearance(
                badgeSymbolName: "wineglass.fill",
                tintColor: .purple,
                assetName: "character_rich",
                roomColors: [
                    Color(red: 0.17, green: 0.12, blue: 0.34),
                    Color(red: 0.46, green: 0.28, blue: 0.62)
                ],
                floorColor: Color(red: 0.28, green: 0.17, blue: 0.30),
                outfitColor: Color(red: 0.60, green: 0.42, blue: 0.80),
                propSymbolName: "sparkles",
                propColor: .purple,
                headAccessorySymbolName: "theatermasks.fill",
                bodyWidthScale: 1.08,
                bodyHeightScale: 1.02,
                postureTiltDegrees: -2,
                headYOffset: -5,
                mouthSymbol: "⌣",
                clutterLevel: 0,
                clutterSymbols: ["sparkles", "wineglass.fill"],
                idleRotationDegrees: 2.2,
                breathScale: 1.04,
                reactionSymbolName: "heart.fill"
            )
        case .comfortable:
            return CharacterAppearance(
                badgeSymbolName: "face.smiling.fill",
                tintColor: .mint,
                assetName: "character_comfortable",
                roomColors: [
                    Color(red: 0.10, green: 0.30, blue: 0.30),
                    Color(red: 0.22, green: 0.54, blue: 0.42)
                ],
                floorColor: Color(red: 0.17, green: 0.34, blue: 0.27),
                outfitColor: Color(red: 0.30, green: 0.75, blue: 0.66),
                propSymbolName: "fork.knife",
                propColor: .mint,
                headAccessorySymbolName: nil,
                bodyWidthScale: 1.02,
                bodyHeightScale: 1.0,
                postureTiltDegrees: -1,
                headYOffset: -2,
                mouthSymbol: "⌣",
                clutterLevel: 1,
                clutterSymbols: ["fork.knife", "leaf.fill"],
                idleRotationDegrees: 1.8,
                breathScale: 1.035,
                reactionSymbolName: "sparkles"
            )
        case .normal:
            return CharacterAppearance(
                badgeSymbolName: "figure.stand",
                tintColor: .blue,
                assetName: "character_normal",
                roomColors: [
                    Color(red: 0.13, green: 0.20, blue: 0.32),
                    Color(red: 0.22, green: 0.34, blue: 0.50)
                ],
                floorColor: Color(red: 0.20, green: 0.25, blue: 0.32),
                outfitColor: Color(red: 0.32, green: 0.50, blue: 0.80),
                propSymbolName: "house.fill",
                propColor: .blue,
                headAccessorySymbolName: nil,
                bodyWidthScale: 0.98,
                bodyHeightScale: 1.0,
                postureTiltDegrees: 1,
                headYOffset: 0,
                mouthSymbol: "ー",
                clutterLevel: 1,
                clutterSymbols: ["cup.and.saucer.fill", "newspaper.fill"],
                idleRotationDegrees: 1.5,
                breathScale: 1.03,
                reactionSymbolName: "hand.thumbsup.fill"
            )
        case .broke:
            return CharacterAppearance(
                badgeSymbolName: "lightbulb.fill",
                tintColor: .gray,
                assetName: "character_broke",
                roomColors: [
                    Color(red: 0.17, green: 0.17, blue: 0.16),
                    Color(red: 0.31, green: 0.29, blue: 0.24)
                ],
                floorColor: Color(red: 0.22, green: 0.20, blue: 0.17),
                outfitColor: Color(red: 0.46, green: 0.46, blue: 0.42),
                propSymbolName: "lightbulb.fill",
                propColor: .orange,
                headAccessorySymbolName: nil,
                bodyWidthScale: 0.88,
                bodyHeightScale: 1.06,
                postureTiltDegrees: 7,
                headYOffset: 8,
                mouthSymbol: "へ",
                clutterLevel: 3,
                clutterSymbols: ["leaf.fill", "shippingbox.fill", "trash.fill"],
                idleRotationDegrees: 3.6,
                breathScale: 1.022,
                reactionSymbolName: "exclamationmark"
            )
        case .extremePoor:
            return CharacterAppearance(
                badgeSymbolName: "shippingbox.fill",
                tintColor: .brown,
                assetName: "character_extremePoor",
                roomColors: [
                    Color(red: 0.13, green: 0.11, blue: 0.09),
                    Color(red: 0.32, green: 0.22, blue: 0.14)
                ],
                floorColor: Color(red: 0.24, green: 0.16, blue: 0.10),
                outfitColor: Color(red: 0.56, green: 0.36, blue: 0.23),
                propSymbolName: "leaf.fill",
                propColor: .green,
                headAccessorySymbolName: nil,
                bodyWidthScale: 0.78,
                bodyHeightScale: 1.12,
                postureTiltDegrees: 10,
                headYOffset: 13,
                mouthSymbol: "…",
                clutterLevel: 4,
                clutterSymbols: ["shippingbox.fill", "leaf.fill", "trash.fill", "lightbulb.fill"],
                idleRotationDegrees: 4.8,
                breathScale: 1.016,
                reactionSymbolName: "questionmark"
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
    @State private var roomMotion = false

    private var appearance: CharacterAppearance { level.appearance }

    var body: some View {
        VStack(spacing: 12) {
            ZStack(alignment: .topTrailing) {
                LivingRoomBackdrop(
                    appearance: appearance,
                    isAmbientAnimating: roomMotion,
                    isReacting: isReacting
                )

                characterArt
                    .id(level)
                    .frame(width: 190, height: 204)
                    .scaleEffect(isReacting ? 1.15 : (isBreathing ? appearance.breathScale : 0.99), anchor: .bottom)
                    .rotationEffect(
                        .degrees(isReacting ? -appearance.idleRotationDegrees : (idleNudge ? appearance.idleRotationDegrees : -appearance.idleRotationDegrees * 0.55))
                    )
                    .offset(y: isReacting ? -18 : 22)
                    .transition(.scale(scale: 0.78).combined(with: .opacity))
                    .animation(.easeInOut(duration: 1.65).repeatForever(autoreverses: true), value: isBreathing)
                    .animation(.spring(response: 0.32, dampingFraction: 0.42), value: isReacting)
                    .animation(.easeInOut(duration: 0.78), value: idleNudge)

                reactionSparkles

                Image(systemName: appearance.badgeSymbolName)
                    .font(.system(size: 22, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(appearance.tintColor)
                    .padding(10)
                    .background(.thinMaterial, in: Circle())
                    .overlay(Circle().stroke(appearance.tintColor.opacity(0.38), lineWidth: 1))
                    .offset(x: -14, y: 16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 304)
            .contentShape(RoundedRectangle(cornerRadius: 32, style: .continuous))
            .onTapGesture(perform: triggerTapReaction)
            .onAppear {
                isBreathing = true
                roomMotion = true
            }
            .task(id: level) {
                await runBlinkLoop()
            }
            .task(id: level.rawValue) {
                await runNudgeLoop()
            }
            .animation(.spring(response: 0.58, dampingFraction: 0.72), value: level)

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
                isReacting: isReacting,
                idleNudge: idleNudge
            )
        }
    }

    @ViewBuilder
    private var reactionSparkles: some View {
        if isReacting {
            ZStack {
                Image(systemName: appearance.reactionSymbolName)
                    .font(.system(size: 30, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(appearance.tintColor)
                    .offset(x: -92, y: 48)
                Image(systemName: "sparkles")
                    .font(.title.weight(.bold))
                    .foregroundStyle(.yellow)
                    .offset(x: 78, y: 82)
                ReactionLines(color: appearance.tintColor)
                    .frame(width: 170, height: 120)
                    .offset(y: 70)
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.48) {
            isReacting = false
        }
    }

    private func runBlinkLoop() async {
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 2_500_000_000)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.08)) {
                    isBlinking = true
                }
            }
            try? await Task.sleep(nanoseconds: 130_000_000)
            await MainActor.run {
                withAnimation(.easeInOut(duration: 0.08)) {
                    isBlinking = false
                }
            }
        }
    }

    private func runNudgeLoop() async {
        while !Task.isCancelled {
            try? await Task.sleep(nanoseconds: 4_600_000_000)
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
    let isAmbientAnimating: Bool
    let isReacting: Bool

    var body: some View {
        GeometryReader { proxy in
            let width = min(proxy.size.width, 344)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 34, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: appearance.roomColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 34, style: .continuous)
                            .stroke(.white.opacity(0.10), lineWidth: 1)
                    )

                AnimatedWallPattern(color: appearance.tintColor, isAnimating: isAmbientAnimating)
                    .opacity(appearance.clutterLevel >= 3 ? 0.18 : 0.28)

                VStack {
                    HStack(alignment: .top) {
                        roomWindow
                            .rotationEffect(.degrees(appearance.clutterLevel >= 3 ? -3 : 0))
                        Spacer()
                        propCluster
                    }
                    .padding(.top, 24)
                    .padding(.horizontal, 28)

                    Spacer()
                }

                RoomClutterView(
                    appearance: appearance,
                    isAmbientAnimating: isAmbientAnimating,
                    isReacting: isReacting
                )
                .padding(.horizontal, 22)
                .padding(.bottom, 38)

                RoundedRectangle(cornerRadius: 26, style: .continuous)
                    .fill(appearance.floorColor.opacity(0.94))
                    .frame(height: 76)
                    .overlay(alignment: .top) {
                        Rectangle()
                            .fill(.white.opacity(0.08))
                            .frame(height: 1)
                    }
            }
            .frame(width: width, height: 282)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .shadow(color: appearance.tintColor.opacity(0.22), radius: 22, y: 12)
        }
    }

    private var roomWindow: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(.white.opacity(0.12))
            .frame(width: 58, height: 44)
            .overlay {
                VStack(spacing: 0) {
                    Rectangle().fill(.white.opacity(0.15)).frame(height: 1)
                    Spacer()
                    Rectangle().fill(.white.opacity(0.15)).frame(height: 1)
                }
                HStack(spacing: 0) {
                    Rectangle().fill(.white.opacity(0.15)).frame(width: 1)
                    Spacer()
                    Rectangle().fill(.white.opacity(0.15)).frame(width: 1)
                }
            }
    }

    private var propCluster: some View {
        Image(systemName: appearance.propSymbolName)
            .font(.system(size: 34, weight: .semibold))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(appearance.propColor)
            .padding(12)
            .background(.black.opacity(0.14), in: Circle())
            .rotationEffect(.degrees(isAmbientAnimating ? 7 : -5))
            .offset(y: isReacting ? -8 : 0)
            .animation(.easeInOut(duration: 1.9).repeatForever(autoreverses: true), value: isAmbientAnimating)
            .animation(.spring(response: 0.28, dampingFraction: 0.5), value: isReacting)
    }
}

private struct AnimatedWallPattern: View {
    let color: Color
    let isAnimating: Bool

    var body: some View {
        VStack(spacing: 24) {
            ForEach(0..<3, id: \.self) { row in
                HStack(spacing: 34) {
                    ForEach(0..<4, id: \.self) { column in
                        Image(systemName: (row + column).isMultiple(of: 2) ? "sparkle" : "line.diagonal")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(color.opacity(0.55))
                            .offset(y: isAnimating ? CGFloat((row + column) % 3) * 3 : -2)
                    }
                }
            }
        }
        .animation(.easeInOut(duration: 2.6).repeatForever(autoreverses: true), value: isAnimating)
    }
}

private struct RoomClutterView: View {
    let appearance: CharacterAppearance
    let isAmbientAnimating: Bool
    let isReacting: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 18) {
            ForEach(0..<appearance.clutterSymbols.count, id: \.self) { index in
                let symbol = appearance.clutterSymbols[index]
                Image(systemName: symbol)
                    .font(.system(size: symbolSize(for: index), weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(color(for: index))
                    .rotationEffect(.degrees(rotation(for: index)))
                    .offset(y: yOffset(for: index))
                    .opacity(opacity(for: index))
                    .animation(.easeInOut(duration: 1.8 + Double(index) * 0.18).repeatForever(autoreverses: true), value: isAmbientAnimating)
                    .animation(.spring(response: 0.34, dampingFraction: 0.52), value: isReacting)
            }
            Spacer(minLength: 0)
        }
    }

    private func symbolSize(for index: Int) -> CGFloat {
        appearance.clutterLevel >= 3 ? CGFloat(22 + index * 3) : CGFloat(18 + index * 2)
    }

    private func color(for index: Int) -> Color {
        if appearance.clutterLevel == 0 {
            return appearance.tintColor
        }
        return index.isMultiple(of: 2) ? appearance.propColor : .white.opacity(0.68)
    }

    private func rotation(for index: Int) -> Double {
        let base = appearance.clutterLevel >= 3 ? Double(index * 9 - 12) : Double(index * 4 - 4)
        return isAmbientAnimating ? base + 5 : base - 3
    }

    private func yOffset(for index: Int) -> CGFloat {
        let base = appearance.clutterLevel >= 3 ? CGFloat(index % 2 == 0 ? 4 : -8) : CGFloat(index % 2 == 0 ? -4 : 2)
        return isReacting ? base - 9 : (isAmbientAnimating ? base - 3 : base + 2)
    }

    private func opacity(for index: Int) -> Double {
        appearance.clutterLevel == 0 ? 0.55 : 0.78
    }
}

private struct AnimatedTanukiPlaceholder: View {
    let appearance: CharacterAppearance
    let isBlinking: Bool
    let isReacting: Bool
    let idleNudge: Bool

    var body: some View {
        ZStack {
            tail
                .offset(x: 62, y: 36)
                .rotationEffect(.degrees(isReacting ? 8 : (idleNudge ? -6 : 2)))

            bodyShape
                .offset(y: 54)

            outfit
                .offset(y: 70)

            head
                .offset(y: -20 + appearance.headYOffset)

            face
                .offset(y: -10 + appearance.headYOffset)

            headAccessory
                .offset(y: -76 + appearance.headYOffset)
        }
        .frame(width: 190, height: 204)
        .rotationEffect(.degrees(appearance.postureTiltDegrees), anchor: .bottom)
    }

    private var isRoughLife: Bool {
        appearance.clutterLevel >= 3
    }

    private var tail: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 0.36, green: 0.26, blue: 0.20))
                .frame(width: 48, height: 104)
                .rotationEffect(.degrees(-28))

            ForEach(0..<4, id: \.self) { index in
                Capsule()
                    .fill(index.isMultiple(of: 2) ? Color(red: 0.88, green: 0.82, blue: 0.70) : Color(red: 0.18, green: 0.16, blue: 0.14))
                    .frame(width: 12, height: 54)
                    .rotationEffect(.degrees(62))
                    .offset(x: CGFloat(index * 9 - 14), y: CGFloat(index * 12 - 14))
            }
        }
        .opacity(isRoughLife ? 0.82 : 1)
    }

    private var bodyShape: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.43, green: 0.30, blue: 0.22))
                .frame(width: 108 * appearance.bodyWidthScale, height: 96 * appearance.bodyHeightScale)

            Ellipse()
                .fill(Color(red: 0.93, green: 0.82, blue: 0.62))
                .frame(width: 58 * appearance.bodyWidthScale, height: 58 * appearance.bodyHeightScale)
                .offset(y: 10)

            if isRoughLife {
                VStack(spacing: 5) {
                    scratch(width: 24)
                    scratch(width: 16)
                }
                .offset(x: -18, y: -10)
            }
        }
    }

    private var outfit: some View {
        RoundedRectangle(cornerRadius: isRoughLife ? 10 : 20, style: .continuous)
            .fill(appearance.outfitColor)
            .frame(width: 82 * appearance.bodyWidthScale, height: 44)
            .overlay(alignment: .center) {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .stroke(.white.opacity(isRoughLife ? 0.16 : 0.30), lineWidth: 1)
                    .padding(7)
            }
            .overlay(alignment: .bottomLeading) {
                if isRoughLife {
                    patch
                        .offset(x: 10, y: -4)
                }
            }
            .overlay(alignment: .topTrailing) {
                if isRoughLife {
                    patch
                        .rotationEffect(.degrees(12))
                        .offset(x: -8, y: 5)
                }
            }
    }

    private var head: some View {
        ZStack {
            HStack(spacing: 56) {
                EarShape()
                    .fill(Color(red: 0.28, green: 0.20, blue: 0.16))
                    .frame(width: 34, height: 36)
                    .rotationEffect(.degrees(isRoughLife ? -28 : -18))
                EarShape()
                    .fill(Color(red: 0.28, green: 0.20, blue: 0.16))
                    .frame(width: 34, height: 36)
                    .rotationEffect(.degrees(isRoughLife ? 30 : 18))
                    .scaleEffect(x: -1, y: 1)
            }
            .offset(y: -35)

            Circle()
                .fill(Color(red: 0.49, green: 0.34, blue: 0.24))
                .frame(width: 96, height: 96)
                .scaleEffect(x: isRoughLife ? 0.92 : 1.0, y: isRoughLife ? 1.04 : 1.0)

            Ellipse()
                .fill(Color(red: 0.92, green: 0.81, blue: 0.63))
                .frame(width: isRoughLife ? 62 : 72, height: 48)
                .offset(y: 13)
        }
    }

    private var face: some View {
        VStack(spacing: 8) {
            HStack(spacing: 23) {
                eye
                eye
            }

            HStack(spacing: 8) {
                if !isRoughLife {
                    Circle()
                        .fill(Color.pink.opacity(0.34))
                        .frame(width: 11, height: 7)
                }
                Text(isReacting ? "♪" : appearance.mouthSymbol)
                    .font(.system(size: isReacting ? 20 : 17, weight: .bold, design: .rounded))
                    .foregroundStyle(Color(red: 0.18, green: 0.12, blue: 0.10))
                    .offset(y: -2)
                if isRoughLife {
                    tear
                        .offset(x: 2, y: -8)
                } else {
                    Circle()
                        .fill(Color.pink.opacity(0.34))
                        .frame(width: 11, height: 7)
                }
            }
        }
    }

    @ViewBuilder
    private var headAccessory: some View {
        if let headAccessorySymbolName = appearance.headAccessorySymbolName {
            Image(systemName: headAccessorySymbolName)
                .font(.system(size: 34, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(appearance.tintColor)
                .rotationEffect(.degrees(-8))
                .offset(x: -2)
        }
    }

    private var eye: some View {
        ZStack {
            if isBlinking {
                Capsule()
                    .fill(Color(red: 0.16, green: 0.10, blue: 0.08))
                    .frame(width: isRoughLife ? 17 : 16, height: 3)
                    .rotationEffect(.degrees(isRoughLife ? 12 : 0))
            } else if isRoughLife {
                Capsule()
                    .fill(Color(red: 0.10, green: 0.07, blue: 0.05))
                    .frame(width: isReacting ? 14 : 12, height: 5)
                    .rotationEffect(.degrees(12))
            } else {
                Circle()
                    .fill(Color(red: 0.10, green: 0.07, blue: 0.05))
                    .frame(width: isReacting ? 13 : 11, height: isReacting ? 13 : 11)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(.white.opacity(0.82))
                            .frame(width: 4, height: 4)
                            .offset(x: 2, y: 2)
                    }
            }
        }
        .frame(width: 20, height: 16)
    }

    private var patch: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(Color(red: 0.30, green: 0.23, blue: 0.18))
            .frame(width: 18, height: 13)
            .overlay {
                VStack(spacing: 3) {
                    Rectangle().fill(.white.opacity(0.20)).frame(height: 1)
                    Rectangle().fill(.white.opacity(0.20)).frame(height: 1)
                }
                .padding(.horizontal, 3)
            }
    }

    private var tear: some View {
        Circle()
            .fill(Color.cyan.opacity(0.75))
            .frame(width: 6, height: 9)
            .scaleEffect(x: 0.78, anchor: .top)
    }

    private func scratch(width: CGFloat) -> some View {
        Capsule()
            .fill(Color.white.opacity(0.22))
            .frame(width: width, height: 2)
            .rotationEffect(.degrees(-12))
    }
}

private struct ReactionLines: View {
    let color: Color

    var body: some View {
        ZStack {
            ForEach(0..<6, id: \.self) { index in
                Capsule()
                    .fill(color.opacity(0.65))
                    .frame(width: 3, height: 22)
                    .rotationEffect(.degrees(Double(index) * 50))
                    .offset(y: -56)
            }
        }
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

#Preview("金欠") {
    CharacterView(level: .broke, line: "今月の財布、薄いのう…")
        .padding()
}

#Preview("極貧") {
    CharacterView(level: .extremePoor, line: "もやし、うまい…")
        .padding()
}
