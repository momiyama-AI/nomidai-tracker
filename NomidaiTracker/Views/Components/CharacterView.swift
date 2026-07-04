import SwiftUI
import UIKit

enum TanukiMouthStyle {
    case grandSmile
    case softSmile
    case pleased
    case calm
    case worried
    case resigned
}

struct CharacterAppearance {
    let badgeSymbolName: String
    let tintColor: Color
    let assetName: String
    let skyColors: [Color]
    let roomWallColor: Color
    let floorColor: Color
    let woodColor: Color
    let outfitColor: Color
    let propSymbolName: String
    let propColor: Color
    let headAccessorySymbolName: String?
    let bodyWidthScale: CGFloat
    let bodyHeightScale: CGFloat
    let postureTiltDegrees: Double
    let headYOffset: CGFloat
    let mouthStyle: TanukiMouthStyle
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
                tintColor: Color(red: 0.98, green: 0.74, blue: 0.18),
                assetName: "character_grandRich",
                skyColors: [
                    Color(red: 0.98, green: 0.63, blue: 0.39),
                    Color(red: 0.99, green: 0.86, blue: 0.55)
                ],
                roomWallColor: Color(red: 0.93, green: 0.70, blue: 0.43),
                floorColor: Color(red: 0.78, green: 0.63, blue: 0.37),
                woodColor: Color(red: 0.42, green: 0.24, blue: 0.12),
                outfitColor: Color(red: 0.94, green: 0.53, blue: 0.14),
                propSymbolName: "yensign.circle.fill",
                propColor: Color(red: 0.98, green: 0.76, blue: 0.18),
                headAccessorySymbolName: "crown.fill",
                bodyWidthScale: 1.15,
                bodyHeightScale: 1.03,
                postureTiltDegrees: -3,
                headYOffset: -8,
                mouthStyle: .grandSmile,
                clutterLevel: 0,
                clutterSymbols: ["sparkles", "yensign.circle.fill", "crown.fill"],
                idleRotationDegrees: 2.6,
                breathScale: 1.045,
                reactionSymbolName: "sparkles"
            )
        case .rich:
            return CharacterAppearance(
                badgeSymbolName: "wineglass.fill",
                tintColor: Color(red: 0.73, green: 0.43, blue: 0.86),
                assetName: "character_rich",
                skyColors: [
                    Color(red: 0.97, green: 0.55, blue: 0.46),
                    Color(red: 0.78, green: 0.61, blue: 0.95)
                ],
                roomWallColor: Color(red: 0.84, green: 0.66, blue: 0.54),
                floorColor: Color(red: 0.63, green: 0.48, blue: 0.34),
                woodColor: Color(red: 0.34, green: 0.19, blue: 0.12),
                outfitColor: Color(red: 0.62, green: 0.38, blue: 0.70),
                propSymbolName: "sparkles",
                propColor: Color(red: 0.82, green: 0.52, blue: 0.94),
                headAccessorySymbolName: "theatermasks.fill",
                bodyWidthScale: 1.08,
                bodyHeightScale: 1.02,
                postureTiltDegrees: -2,
                headYOffset: -5,
                mouthStyle: .pleased,
                clutterLevel: 0,
                clutterSymbols: ["sparkles", "wineglass.fill"],
                idleRotationDegrees: 2.2,
                breathScale: 1.04,
                reactionSymbolName: "heart.fill"
            )
        case .comfortable:
            return CharacterAppearance(
                badgeSymbolName: "face.smiling.fill",
                tintColor: Color(red: 0.24, green: 0.72, blue: 0.55),
                assetName: "character_comfortable",
                skyColors: [
                    Color(red: 0.98, green: 0.66, blue: 0.42),
                    Color(red: 0.72, green: 0.86, blue: 0.58)
                ],
                roomWallColor: Color(red: 0.80, green: 0.66, blue: 0.47),
                floorColor: Color(red: 0.64, green: 0.72, blue: 0.42),
                woodColor: Color(red: 0.38, green: 0.23, blue: 0.13),
                outfitColor: Color(red: 0.31, green: 0.67, blue: 0.56),
                propSymbolName: "fork.knife",
                propColor: Color(red: 0.34, green: 0.72, blue: 0.50),
                headAccessorySymbolName: nil,
                bodyWidthScale: 1.03,
                bodyHeightScale: 1.0,
                postureTiltDegrees: -1,
                headYOffset: -2,
                mouthStyle: .softSmile,
                clutterLevel: 1,
                clutterSymbols: ["fork.knife", "leaf.fill"],
                idleRotationDegrees: 1.8,
                breathScale: 1.035,
                reactionSymbolName: "sparkles"
            )
        case .normal:
            return CharacterAppearance(
                badgeSymbolName: "house.fill",
                tintColor: Color(red: 0.31, green: 0.64, blue: 0.89),
                assetName: "character_normal",
                skyColors: [
                    Color(red: 0.88, green: 0.56, blue: 0.43),
                    Color(red: 0.58, green: 0.72, blue: 0.85)
                ],
                roomWallColor: Color(red: 0.70, green: 0.59, blue: 0.45),
                floorColor: Color(red: 0.54, green: 0.65, blue: 0.42),
                woodColor: Color(red: 0.31, green: 0.19, blue: 0.12),
                outfitColor: Color(red: 0.34, green: 0.50, blue: 0.72),
                propSymbolName: "cup.and.saucer.fill",
                propColor: Color(red: 0.38, green: 0.63, blue: 0.88),
                headAccessorySymbolName: nil,
                bodyWidthScale: 0.98,
                bodyHeightScale: 1.0,
                postureTiltDegrees: 1,
                headYOffset: 0,
                mouthStyle: .calm,
                clutterLevel: 1,
                clutterSymbols: ["cup.and.saucer.fill", "newspaper.fill"],
                idleRotationDegrees: 1.5,
                breathScale: 1.03,
                reactionSymbolName: "hand.thumbsup.fill"
            )
        case .broke:
            return CharacterAppearance(
                badgeSymbolName: "lightbulb.fill",
                tintColor: Color(red: 0.78, green: 0.60, blue: 0.32),
                assetName: "character_broke",
                skyColors: [
                    Color(red: 0.52, green: 0.44, blue: 0.38),
                    Color(red: 0.37, green: 0.38, blue: 0.35)
                ],
                roomWallColor: Color(red: 0.46, green: 0.39, blue: 0.30),
                floorColor: Color(red: 0.42, green: 0.41, blue: 0.30),
                woodColor: Color(red: 0.25, green: 0.19, blue: 0.14),
                outfitColor: Color(red: 0.48, green: 0.47, blue: 0.39),
                propSymbolName: "lightbulb.fill",
                propColor: Color(red: 0.95, green: 0.66, blue: 0.24),
                headAccessorySymbolName: nil,
                bodyWidthScale: 0.89,
                bodyHeightScale: 1.07,
                postureTiltDegrees: 7,
                headYOffset: 8,
                mouthStyle: .worried,
                clutterLevel: 3,
                clutterSymbols: ["leaf.fill", "shippingbox.fill", "trash.fill"],
                idleRotationDegrees: 3.6,
                breathScale: 1.022,
                reactionSymbolName: "exclamationmark"
            )
        case .extremePoor:
            return CharacterAppearance(
                badgeSymbolName: "shippingbox.fill",
                tintColor: Color(red: 0.66, green: 0.43, blue: 0.26),
                assetName: "character_extremePoor",
                skyColors: [
                    Color(red: 0.32, green: 0.28, blue: 0.24),
                    Color(red: 0.22, green: 0.24, blue: 0.23)
                ],
                roomWallColor: Color(red: 0.34, green: 0.27, blue: 0.21),
                floorColor: Color(red: 0.36, green: 0.31, blue: 0.22),
                woodColor: Color(red: 0.21, green: 0.15, blue: 0.11),
                outfitColor: Color(red: 0.56, green: 0.35, blue: 0.23),
                propSymbolName: "leaf.fill",
                propColor: Color(red: 0.45, green: 0.64, blue: 0.35),
                headAccessorySymbolName: nil,
                bodyWidthScale: 0.78,
                bodyHeightScale: 1.13,
                postureTiltDegrees: 10,
                headYOffset: 13,
                mouthStyle: .resigned,
                clutterLevel: 4,
                clutterSymbols: ["shippingbox.fill", "leaf.fill", "trash.fill", "lightbulb.fill"],
                idleRotationDegrees: 4.8,
                breathScale: 1.016,
                reactionSymbolName: "questionmark"
            )
        }
    }
}

/// Nomidanuki visual surface. If assets matching `assetName` are added later,
/// the SwiftUI placeholder is automatically replaced by those images.
struct CharacterView: View {
    let level: WealthLevel
    let line: String

    @State private var isBreathing = false
    @State private var isBlinking = false
    @State private var isReacting = false
    @State private var idleNudge = false
    @State private var roomMotion = false

    private let referenceSceneImageName = "NomidanukiLifeScene"
    private var appearance: CharacterAppearance { level.appearance }

    var body: some View {
        Group {
            if UIImage(named: referenceSceneImageName) != nil {
                ReferenceLifeSceneView(imageName: referenceSceneImageName, level: level, line: line)
            } else {
                animatedPlaceholderStage
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(Text(NSLocalizedString(level.localizationKey, comment: "")))
        .accessibilityValue(Text(line))
    }

    private var animatedPlaceholderStage: some View {
        VStack(spacing: 10) {
            ZStack(alignment: .topTrailing) {
                StorybookLifeBackdrop(
                    appearance: appearance,
                    isAmbientAnimating: roomMotion,
                    isReacting: isReacting
                )

                characterArt
                    .id(level)
                    .frame(width: 204, height: 228)
                    .scaleEffect(isReacting ? 1.14 : (isBreathing ? appearance.breathScale : 0.99), anchor: .bottom)
                    .rotationEffect(
                        .degrees(isReacting ? -appearance.idleRotationDegrees : (idleNudge ? appearance.idleRotationDegrees : -appearance.idleRotationDegrees * 0.55))
                    )
                    .offset(x: appearance.clutterLevel >= 3 ? 34 : 46, y: isReacting ? 50 : 66)
                    .transition(.scale(scale: 0.78).combined(with: .opacity))
                    .animation(.easeInOut(duration: 1.65).repeatForever(autoreverses: true), value: isBreathing)
                    .animation(.spring(response: 0.32, dampingFraction: 0.42), value: isReacting)
                    .animation(.easeInOut(duration: 0.78), value: idleNudge)

                reactionSparkles

                LifestyleBadge(appearance: appearance)
                    .offset(x: -16, y: 16)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 334)
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

            SpeechBubbleView(text: line, appearance: appearance)
                .id(line)
                .transition(.opacity.combined(with: .move(edge: .top)))
                .animation(.easeInOut(duration: 0.25), value: line)
        }
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
                    .font(.system(size: 32, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(appearance.tintColor)
                    .offset(x: -104, y: 58)
                Image(systemName: "sparkles")
                    .font(.title.weight(.bold))
                    .foregroundStyle(Color(red: 0.99, green: 0.81, blue: 0.27))
                    .offset(x: 88, y: 96)
                ReactionLines(color: appearance.tintColor)
                    .frame(width: 176, height: 126)
                    .offset(x: 42, y: 88)
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

private struct ReferenceLifeSceneView: View {
    let imageName: String
    let level: WealthLevel
    let line: String

    @State private var isBreathing = false
    @State private var idleSway = false
    @State private var isPressed = false
    @State private var ambientPulse = false

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .scaleEffect(isPressed ? 0.992 : (isBreathing ? 1.010 : 1.0), anchor: .center)
                    .offset(x: idleSway ? 1.6 : -1.0, y: isBreathing ? -1.8 : 1.2)
                    .clipped()

                ReferenceLifestyleOverlay(
                    level: level,
                    line: line,
                    isBreathing: isBreathing,
                    idleSway: idleSway,
                    isPressed: isPressed,
                    ambientPulse: ambientPulse
                )
            }
            .frame(width: proxy.size.width, height: proxy.size.height)
        }
        .aspectRatio(797.0 / 690.0, contentMode: .fit)
        .frame(maxWidth: .infinity)
        .clipShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .contentShape(RoundedRectangle(cornerRadius: 28, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .stroke(level.referenceAccentColor.opacity(0.26), lineWidth: 1.4)
        }
        .shadow(color: level.referenceAccentColor.opacity(level.referenceShadowOpacity), radius: 20, y: 10)
        .animation(.spring(response: 0.28, dampingFraction: 0.62), value: isPressed)
        .animation(.easeInOut(duration: 0.45), value: level)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                isBreathing = true
            }
            withAnimation(.easeInOut(duration: 3.4).repeatForever(autoreverses: true)) {
                idleSway = true
            }
            withAnimation(.easeInOut(duration: 2.2).repeatForever(autoreverses: true)) {
                ambientPulse = true
            }
        }
        .onTapGesture {
            isPressed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.26) {
                isPressed = false
            }
        }
        .accessibilityLabel(Text(NSLocalizedString(level.localizationKey, comment: "")))
        .accessibilityValue(Text(line))
    }
}

private struct ReferenceLifestyleOverlay: View {
    let level: WealthLevel
    let line: String
    let isBreathing: Bool
    let idleSway: Bool
    let isPressed: Bool
    let ambientPulse: Bool

    var body: some View {
        GeometryReader { proxy in
            let width = proxy.size.width
            let height = proxy.size.height

            ZStack {
                level.referenceMoodWash

                ReferenceRichnessLayer(
                    level: level,
                    width: width,
                    height: height,
                    idleSway: idleSway,
                    ambientPulse: ambientPulse
                )

                ReferencePovertyLayer(
                    level: level,
                    width: width,
                    height: height,
                    idleSway: idleSway,
                    ambientPulse: ambientPulse
                )

                ReferenceSteamView(isAnimating: ambientPulse)
                    .frame(width: width * 0.13, height: height * 0.12)
                    .position(x: width * 0.63, y: height * 0.57)
                    .opacity(level.referenceSteamOpacity)

                ReferenceHeadLeafView(isAnimating: idleSway)
                    .frame(width: width * 0.062, height: height * 0.038)
                    .rotationEffect(.degrees(idleSway ? 7 : -6))
                    .scaleEffect(isBreathing ? 1.05 : 0.96)
                    .position(x: width * 0.565, y: height * 0.455)

                ReferenceSpeechText(text: line, level: level)
                    .frame(width: width * 0.24)
                    .position(x: width * 0.56, y: height * 0.355)

                if isPressed {
                    ReferenceTapReaction(color: level.referenceAccentColor)
                        .frame(width: width * 0.32, height: height * 0.18)
                        .position(x: width * 0.62, y: height * 0.46)
                        .transition(.scale(scale: 0.7).combined(with: .opacity))
                }
            }
            .drawingGroup()
        }
    }
}

private struct ReferenceRichnessLayer: View {
    let level: WealthLevel
    let width: CGFloat
    let height: CGFloat
    let idleSway: Bool
    let ambientPulse: Bool

    private var intensity: Double {
        switch level {
        case .grandRich: return 1
        case .rich: return 0.72
        case .comfortable: return 0.30
        default: return 0
        }
    }

    var body: some View {
        if intensity > 0 {
            ZStack {
                ForEach(0..<6, id: \.self) { index in
                    Image(systemName: index.isMultiple(of: 2) ? "yensign.circle.fill" : "sparkle")
                        .font(.system(size: CGFloat(12 + index * 2), weight: .bold))
                        .symbolRenderingMode(.hierarchical)
                        .foregroundStyle(Color(red: 1.0, green: 0.78, blue: 0.22))
                        .opacity((0.34 + Double(index % 3) * 0.10) * intensity)
                        .position(
                            x: width * CGFloat([0.14, 0.28, 0.78, 0.88, 0.20, 0.72][index]),
                            y: height * CGFloat([0.16, 0.30, 0.17, 0.37, 0.68, 0.61][index])
                        )
                        .offset(y: ambientPulse ? CGFloat(index % 2 == 0 ? -7 : 6) : CGFloat(index % 2 == 0 ? 5 : -6))
                }

                Image(systemName: level == .grandRich ? "crown.fill" : "sparkles")
                    .font(.system(size: width * (level == .grandRich ? 0.075 : 0.060), weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color(red: 1.0, green: 0.80, blue: 0.22))
                    .shadow(color: .black.opacity(0.22), radius: 4, y: 2)
                    .position(x: width * 0.58, y: height * 0.405)
                    .offset(y: idleSway ? -5 : 1)
                    .opacity(0.92 * intensity)
            }
        }
    }
}

private struct ReferencePovertyLayer: View {
    let level: WealthLevel
    let width: CGFloat
    let height: CGFloat
    let idleSway: Bool
    let ambientPulse: Bool

    private var intensity: Double {
        switch level {
        case .broke: return 0.60
        case .extremePoor: return 0.95
        default: return 0
        }
    }

    var body: some View {
        if intensity > 0 {
            ZStack {
                Color.black.opacity(0.15 * intensity)

                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color(red: 0.55, green: 0.36, blue: 0.20).opacity(0.92))
                    .overlay {
                        VStack(spacing: 5) {
                            Rectangle().fill(Color.black.opacity(0.18)).frame(height: 1)
                            Rectangle().fill(Color.black.opacity(0.18)).frame(height: 1)
                        }
                        .padding(.horizontal, 8)
                    }
                    .overlay(RoundedRectangle(cornerRadius: 8, style: .continuous).stroke(Color.black.opacity(0.24), lineWidth: 1))
                    .frame(width: width * 0.14, height: height * 0.08)
                    .rotationEffect(.degrees(-5))
                    .position(x: width * 0.86, y: height * 0.78)
                    .opacity(0.76 * intensity)

                Image(systemName: "lightbulb.fill")
                    .font(.system(size: width * 0.060, weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(Color(red: 1.0, green: 0.70, blue: 0.24))
                    .shadow(color: Color.orange.opacity(ambientPulse ? 0.62 : 0.18), radius: ambientPulse ? 12 : 4)
                    .position(x: width * 0.79, y: height * 0.19)
                    .opacity((level == .extremePoor ? 0.92 : 0.62) * intensity)

                MoyashiBowl(woodColor: Color(red: 0.22, green: 0.13, blue: 0.08))
                    .frame(width: width * 0.12, height: height * 0.075)
                    .position(x: width * 0.63, y: height * 0.66)
                    .offset(y: idleSway ? 1.5 : -1.5)
                    .opacity(0.80 * intensity)

                ForEach(0..<3, id: \.self) { index in
                    Capsule()
                        .fill(Color.white.opacity(0.56))
                        .frame(width: width * 0.010, height: height * 0.038)
                        .rotationEffect(.degrees(Double(index * 18 - 18)))
                        .position(x: width * CGFloat(0.58 + Double(index) * 0.022), y: height * 0.50)
                        .offset(y: ambientPulse ? 5 : -2)
                        .opacity(0.55 * intensity)
                }
            }
        }
    }
}

private struct ReferenceSpeechText: View {
    let text: String
    let level: WealthLevel

    var body: some View {
        Text(text)
            .font(.system(size: 10.5, weight: .bold, design: .rounded))
            .foregroundStyle(Color(red: 0.26, green: 0.15, blue: 0.08))
            .multilineTextAlignment(.center)
            .lineLimit(2)
            .minimumScaleFactor(0.62)
            .padding(.horizontal, 4)
            .opacity(level == .normal ? 0.78 : 0.95)
    }
}

private struct ReferenceSteamView: View {
    let isAnimating: Bool

    var body: some View {
        ZStack {
            ForEach(0..<3, id: \.self) { index in
                Capsule()
                    .stroke(Color.white.opacity(0.50), lineWidth: 1.6)
                    .frame(width: CGFloat(10 + index * 3), height: CGFloat(28 + index * 5))
                    .rotationEffect(.degrees(Double(index * 13 - 13)))
                    .offset(x: CGFloat(index * 9 - 9), y: isAnimating ? -13 : -2)
                    .opacity(isAnimating ? 0.12 : 0.42)
            }
        }
    }
}

private struct ReferenceHeadLeafView: View {
    let isAnimating: Bool

    var body: some View {
        LeafShape()
            .fill(
                LinearGradient(
                    colors: [
                        Color(red: 0.52, green: 0.78, blue: 0.28),
                        Color(red: 0.22, green: 0.52, blue: 0.19)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(LeafShape().stroke(Color(red: 0.18, green: 0.31, blue: 0.10), lineWidth: 1))
            .shadow(color: .black.opacity(0.20), radius: 2, y: 1)
            .offset(y: isAnimating ? -2 : 1)
    }
}

private struct ReferenceTapReaction: View {
    let color: Color

    var body: some View {
        ZStack {
            ForEach(0..<7, id: \.self) { index in
                Image(systemName: index.isMultiple(of: 2) ? "sparkle" : "heart.fill")
                    .font(.system(size: CGFloat(12 + index), weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(index.isMultiple(of: 2) ? Color(red: 1.0, green: 0.78, blue: 0.22) : color)
                    .offset(
                        x: CGFloat(index * 17 - 52),
                        y: CGFloat((index % 3) * 18 - 28)
                    )
            }
        }
    }
}

private extension WealthLevel {
    var referenceAccentColor: Color {
        switch self {
        case .grandRich:
            return Color(red: 1.0, green: 0.78, blue: 0.22)
        case .rich:
            return Color(red: 0.82, green: 0.52, blue: 0.92)
        case .comfortable:
            return Color(red: 0.38, green: 0.76, blue: 0.50)
        case .normal:
            return Color(red: 0.90, green: 0.56, blue: 0.30)
        case .broke:
            return Color(red: 0.78, green: 0.56, blue: 0.28)
        case .extremePoor:
            return Color(red: 0.52, green: 0.34, blue: 0.23)
        }
    }

    var referenceShadowOpacity: Double {
        switch self {
        case .grandRich, .rich:
            return 0.22
        case .comfortable:
            return 0.14
        case .normal:
            return 0.10
        case .broke, .extremePoor:
            return 0.05
        }
    }

    @ViewBuilder
    var referenceMoodWash: some View {
        switch self {
        case .grandRich:
            LinearGradient(
                colors: [Color.yellow.opacity(0.12), Color.clear, Color.orange.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .rich:
            LinearGradient(
                colors: [Color.purple.opacity(0.08), Color.clear, Color.yellow.opacity(0.05)],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        case .comfortable:
            Color.green.opacity(0.035)
        case .normal:
            Color.clear
        case .broke:
            Color.black.opacity(0.05)
        case .extremePoor:
            Color.black.opacity(0.12)
        }
    }

    var referenceSteamOpacity: Double {
        switch self {
        case .grandRich, .rich, .comfortable, .normal:
            return 1.0
        case .broke:
            return 0.72
        case .extremePoor:
            return 0.36
        }
    }
}

private struct StorybookLifeBackdrop: View {
    let appearance: CharacterAppearance
    let isAmbientAnimating: Bool
    let isReacting: Bool

    var body: some View {
        GeometryReader { proxy in
            let width = min(proxy.size.width, 366)

            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(Color(red: 0.17, green: 0.12, blue: 0.09))

                HStack(spacing: 0) {
                    CountrysidePanel(
                        appearance: appearance,
                        isAmbientAnimating: isAmbientAnimating
                    )
                    .frame(width: width * 0.48)

                    JapaneseRoomPanel(
                        appearance: appearance,
                        isAmbientAnimating: isAmbientAnimating
                    )
                    .frame(width: width * 0.52)
                }

                TatamiFloor(appearance: appearance)
                    .frame(height: 112)

                RoomLifeProps(
                    appearance: appearance,
                    isAmbientAnimating: isAmbientAnimating,
                    isReacting: isReacting
                )
                .padding(.horizontal, 18)
                .padding(.bottom, 18)

                SketchTexture(color: appearance.woodColor)
                    .opacity(0.18)

                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .stroke(appearance.woodColor.opacity(0.70), lineWidth: 2)
                    .overlay {
                        RoundedRectangle(cornerRadius: 30, style: .continuous)
                            .stroke(.white.opacity(0.22), lineWidth: 1)
                            .padding(2)
                    }
            }
            .clipShape(RoundedRectangle(cornerRadius: 30, style: .continuous))
            .frame(width: width, height: 316)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .shadow(color: appearance.tintColor.opacity(0.26), radius: 22, y: 12)
        }
    }
}

private struct CountrysidePanel: View {
    let appearance: CharacterAppearance
    let isAmbientAnimating: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            LinearGradient(
                colors: appearance.skyColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color(red: 1.0, green: 0.78, blue: 0.38).opacity(0.92))
                .frame(width: 58, height: 58)
                .blur(radius: 0.4)
                .offset(x: -38, y: -106)

            MountainRange(peakOffset: 22)
            .fill(Color(red: 0.55, green: 0.43, blue: 0.31).opacity(0.78))
            .frame(height: 88)
            .offset(y: -74)

            MountainRange(peakOffset: -12)
            .fill(Color(red: 0.35, green: 0.49, blue: 0.32).opacity(0.82))
            .frame(height: 78)
            .offset(y: -54)

            VillagePath()
                .fill(Color(red: 0.83, green: 0.70, blue: 0.48))
                .frame(height: 104)
                .offset(y: -8)
                .overlay {
                    VillagePath()
                        .stroke(appearance.woodColor.opacity(0.24), lineWidth: 1.4)
                        .frame(height: 104)
                        .offset(y: -8)
                }

            HStack(alignment: .bottom, spacing: 8) {
                MiniHouse(roofColor: Color(red: 0.40, green: 0.20, blue: 0.12))
                    .frame(width: 44, height: 42)
                MiniHouse(roofColor: Color(red: 0.47, green: 0.25, blue: 0.14))
                    .frame(width: 36, height: 34)
                    .offset(y: -8)
            }
            .offset(x: -36, y: -70)

            AutumnTree(color: Color(red: 0.86, green: 0.31, blue: 0.15))
                .frame(width: 70, height: 118)
                .offset(x: -78, y: -42)

            AutumnTree(color: Color(red: 0.91, green: 0.68, blue: 0.22))
                .frame(width: 48, height: 82)
                .offset(x: 58, y: -56)

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(appearance.woodColor.opacity(0.42), lineWidth: 5)
                .frame(width: 108, height: 136)
                .offset(x: 76, y: -38)
                .opacity(0.42)
        }
        .overlay(alignment: .topLeading) {
            ForEach(0..<7, id: \.self) { index in
                LeafShape()
                    .fill(index.isMultiple(of: 2) ? Color(red: 0.90, green: 0.36, blue: 0.16) : Color(red: 0.95, green: 0.68, blue: 0.24))
                    .frame(width: 12, height: 16)
                    .rotationEffect(.degrees(Double(index * 34)))
                    .offset(
                        x: CGFloat(index * 15 - 12),
                        y: CGFloat((index % 3) * 15 + 8) + (isAmbientAnimating ? 3 : -2)
                    )
            }
            .animation(.easeInOut(duration: 2.7).repeatForever(autoreverses: true), value: isAmbientAnimating)
        }
    }
}

private struct JapaneseRoomPanel: View {
    let appearance: CharacterAppearance
    let isAmbientAnimating: Bool

    var body: some View {
        ZStack {
            appearance.roomWallColor

            VStack(spacing: 0) {
                HStack(spacing: 6) {
                    ShojiWindow(woodColor: appearance.woodColor)
                        .frame(width: 54, height: 96)
                    Shelf(appearance: appearance, isAmbientAnimating: isAmbientAnimating)
                        .frame(width: 76, height: 86)
                        .offset(y: 8)
                }
                .padding(.top, 24)
                .padding(.trailing, 8)

                Spacer()
            }

            VStack {
                CeilingBeams(woodColor: appearance.woodColor)
                    .frame(height: 52)
                Spacer()
            }

            HStack {
                Spacer()
                HangingClock(woodColor: appearance.woodColor)
                    .frame(width: 30, height: 58)
                    .offset(x: -20, y: -80)
            }

            if appearance.clutterLevel <= 1 {
                SparkleCluster(color: appearance.tintColor)
                    .frame(width: 90, height: 70)
                    .offset(x: 18, y: -86)
                    .opacity(0.56)
            }

            if appearance.clutterLevel >= 3 {
                DimRoomOverlay()
            }
        }
    }
}

private struct RoomLifeProps: View {
    let appearance: CharacterAppearance
    let isAmbientAnimating: Bool
    let isReacting: Bool

    var body: some View {
        ZStack(alignment: .bottom) {
            HStack(alignment: .bottom) {
                roomLeftProps
                Spacer()
                roomRightProps
            }

            LowTable(appearance: appearance)
                .frame(width: appearance.clutterLevel >= 3 ? 108 : 128, height: 56)
                .offset(x: appearance.clutterLevel >= 3 ? -18 : 0, y: -18)
                .scaleEffect(isReacting ? 1.04 : 1.0, anchor: .bottom)
                .animation(.spring(response: 0.28, dampingFraction: 0.62), value: isReacting)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottom)
    }

    @ViewBuilder
    private var roomLeftProps: some View {
        VStack(alignment: .leading, spacing: 7) {
            if appearance.clutterLevel >= 3 {
                BareBulb(appearance: appearance)
                    .frame(width: 34, height: 58)
                CardboardBox(woodColor: appearance.woodColor)
                    .frame(width: 54, height: 44)
                    .rotationEffect(.degrees(-5))
            } else {
                Cushion(color: appearance.tintColor.opacity(0.82), woodColor: appearance.woodColor)
                    .frame(width: 74, height: 30)
                TeaKettle(woodColor: appearance.woodColor)
                    .frame(width: 46, height: 38)
                    .offset(x: 8)
            }
        }
        .offset(y: appearance.clutterLevel >= 3 ? -16 : -12)
    }

    @ViewBuilder
    private var roomRightProps: some View {
        VStack(alignment: .trailing, spacing: 8) {
            if appearance.clutterLevel >= 4 {
                CardboardBox(woodColor: appearance.woodColor)
                    .frame(width: 70, height: 48)
                    .rotationEffect(.degrees(6))
                RoomClutterSymbols(appearance: appearance, isAmbientAnimating: isAmbientAnimating)
            } else if appearance.clutterLevel >= 3 {
                RoomClutterSymbols(appearance: appearance, isAmbientAnimating: isAmbientAnimating)
                Futon(color: Color(red: 0.56, green: 0.46, blue: 0.38), woodColor: appearance.woodColor)
                    .frame(width: 72, height: 32)
            } else {
                Futon(color: Color(red: 0.84, green: 0.43, blue: 0.35), woodColor: appearance.woodColor)
                    .frame(width: 76, height: 34)
                RoomClutterSymbols(appearance: appearance, isAmbientAnimating: isAmbientAnimating)
            }
        }
        .offset(y: -10)
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
                .offset(x: 66, y: 38)
                .rotationEffect(.degrees(isReacting ? 8 : (idleNudge ? -6 : 2)))

            bodyShape
                .offset(y: 54)

            arms
                .offset(y: 56)

            outfit
                .offset(y: 70)

            head
                .offset(y: -22 + appearance.headYOffset)

            face
                .offset(y: -10 + appearance.headYOffset)

            headAccessory
                .offset(y: -78 + appearance.headYOffset)
        }
        .frame(width: 204, height: 228)
        .rotationEffect(.degrees(appearance.postureTiltDegrees), anchor: .bottom)
    }

    private var isRoughLife: Bool {
        appearance.clutterLevel >= 3
    }

    private var outlineColor: Color {
        Color(red: 0.20, green: 0.12, blue: 0.08)
    }

    private var tail: some View {
        ZStack {
            Capsule()
                .fill(Color(red: 0.41, green: 0.28, blue: 0.19))
                .overlay(Capsule().stroke(outlineColor.opacity(0.78), lineWidth: 2))
                .frame(width: 52, height: 114)
                .rotationEffect(.degrees(-28))

            ForEach(0..<4, id: \.self) { index in
                Capsule()
                    .fill(index.isMultiple(of: 2) ? Color(red: 0.88, green: 0.81, blue: 0.65) : Color(red: 0.19, green: 0.15, blue: 0.12))
                    .frame(width: 12, height: 58)
                    .rotationEffect(.degrees(62))
                    .offset(x: CGFloat(index * 10 - 16), y: CGFloat(index * 13 - 16))
            }
        }
        .opacity(isRoughLife ? 0.84 : 1)
    }

    private var bodyShape: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.47, green: 0.31, blue: 0.20))
                .overlay(Ellipse().stroke(outlineColor.opacity(0.82), lineWidth: 2.4))
                .frame(width: 116 * appearance.bodyWidthScale, height: 106 * appearance.bodyHeightScale)

            Ellipse()
                .fill(Color(red: 0.94, green: 0.80, blue: 0.58))
                .overlay(Ellipse().stroke(outlineColor.opacity(0.24), lineWidth: 1))
                .frame(width: 66 * appearance.bodyWidthScale, height: 64 * appearance.bodyHeightScale)
                .offset(y: 12)

            if isRoughLife {
                VStack(spacing: 6) {
                    scratch(width: 28)
                    scratch(width: 18)
                }
                .offset(x: -20, y: -12)
            }
        }
    }

    private var arms: some View {
        HStack(spacing: 76) {
            Capsule()
                .fill(Color(red: 0.38, green: 0.25, blue: 0.17))
                .overlay(Capsule().stroke(outlineColor.opacity(0.58), lineWidth: 1.4))
                .frame(width: 22, height: 58)
                .rotationEffect(.degrees(isRoughLife ? 16 : -10))
            Capsule()
                .fill(Color(red: 0.38, green: 0.25, blue: 0.17))
                .overlay(Capsule().stroke(outlineColor.opacity(0.58), lineWidth: 1.4))
                .frame(width: 22, height: 58)
                .rotationEffect(.degrees(isReacting ? -42 : (isRoughLife ? -10 : 15)))
        }
    }

    private var outfit: some View {
        RoundedRectangle(cornerRadius: isRoughLife ? 10 : 18, style: .continuous)
            .fill(appearance.outfitColor)
            .overlay(
                RoundedRectangle(cornerRadius: isRoughLife ? 10 : 18, style: .continuous)
                    .stroke(outlineColor.opacity(0.62), lineWidth: 2)
            )
            .frame(width: 86 * appearance.bodyWidthScale, height: 48)
            .overlay {
                VStack(spacing: 5) {
                    Rectangle()
                        .fill(.white.opacity(isRoughLife ? 0.12 : 0.24))
                        .frame(height: 1)
                    HStack(spacing: 8) {
                        ForEach(0..<3, id: \.self) { _ in
                            Circle()
                                .fill(.white.opacity(isRoughLife ? 0.16 : 0.38))
                                .frame(width: 4, height: 4)
                        }
                    }
                }
                .padding(.horizontal, 10)
            }
            .overlay(alignment: .bottomLeading) {
                if isRoughLife {
                    patch
                        .offset(x: 10, y: -5)
                }
            }
            .overlay(alignment: .topTrailing) {
                if isRoughLife {
                    patch
                        .rotationEffect(.degrees(12))
                        .offset(x: -8, y: 6)
                }
            }
    }

    private var head: some View {
        ZStack {
            HStack(spacing: 60) {
                EarShape()
                    .fill(Color(red: 0.33, green: 0.21, blue: 0.15))
                    .overlay(EarShape().stroke(outlineColor.opacity(0.72), lineWidth: 2))
                    .frame(width: 38, height: 40)
                    .rotationEffect(.degrees(isRoughLife ? -28 : -18))
                EarShape()
                    .fill(Color(red: 0.33, green: 0.21, blue: 0.15))
                    .overlay(EarShape().stroke(outlineColor.opacity(0.72), lineWidth: 2))
                    .frame(width: 38, height: 40)
                    .rotationEffect(.degrees(isRoughLife ? 30 : 18))
                    .scaleEffect(x: -1, y: 1)
            }
            .offset(y: -38)

            Circle()
                .fill(Color(red: 0.53, green: 0.35, blue: 0.23))
                .overlay(Circle().stroke(outlineColor.opacity(0.82), lineWidth: 2.4))
                .frame(width: 104, height: 104)
                .scaleEffect(x: isRoughLife ? 0.92 : 1.0, y: isRoughLife ? 1.04 : 1.0)

            Ellipse()
                .fill(Color(red: 0.94, green: 0.80, blue: 0.59))
                .overlay(Ellipse().stroke(outlineColor.opacity(0.20), lineWidth: 1))
                .frame(width: isRoughLife ? 66 : 76, height: 52)
                .offset(y: 14)

            HStack(spacing: 32) {
                FaceMask()
                    .fill(Color(red: 0.22, green: 0.14, blue: 0.10))
                    .frame(width: 34, height: 28)
                    .rotationEffect(.degrees(-8))
                FaceMask()
                    .fill(Color(red: 0.22, green: 0.14, blue: 0.10))
                    .frame(width: 34, height: 28)
                    .rotationEffect(.degrees(8))
                    .scaleEffect(x: -1, y: 1)
            }
            .offset(y: -4)
            .opacity(0.84)
        }
    }

    private var face: some View {
        VStack(spacing: 8) {
            HStack(spacing: 24) {
                eye
                eye
            }

            ZStack {
                HStack(spacing: 40) {
                    if !isRoughLife {
                        cheek
                        cheek
                    } else {
                        tear
                            .opacity(isReacting ? 0.2 : 1.0)
                        Color.clear.frame(width: 9, height: 9)
                    }
                }
                MouthShape(style: isReacting ? .grandSmile : appearance.mouthStyle)
                    .stroke(Color(red: 0.15, green: 0.08, blue: 0.06), style: StrokeStyle(lineWidth: 2.3, lineCap: .round, lineJoin: .round))
                    .frame(width: 30, height: 18)
                    .offset(y: 0)
            }
            .frame(height: 20)
        }
    }

    @ViewBuilder
    private var headAccessory: some View {
        if let headAccessorySymbolName = appearance.headAccessorySymbolName {
            Image(systemName: headAccessorySymbolName)
                .font(.system(size: 34, weight: .black))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(appearance.tintColor)
                .shadow(color: outlineColor.opacity(0.34), radius: 1, y: 1)
                .rotationEffect(.degrees(-8))
                .offset(x: -2)
        }
    }

    private var eye: some View {
        ZStack {
            if isBlinking {
                Capsule()
                    .fill(Color(red: 0.13, green: 0.08, blue: 0.05))
                    .frame(width: isRoughLife ? 17 : 16, height: 3)
                    .rotationEffect(.degrees(isRoughLife ? 12 : 0))
            } else if isRoughLife {
                Capsule()
                    .fill(Color(red: 0.10, green: 0.06, blue: 0.04))
                    .frame(width: isReacting ? 15 : 13, height: 5)
                    .rotationEffect(.degrees(12))
            } else {
                Circle()
                    .fill(Color(red: 0.09, green: 0.05, blue: 0.04))
                    .frame(width: isReacting ? 14 : 12, height: isReacting ? 14 : 12)
                    .overlay(alignment: .topLeading) {
                        Circle()
                            .fill(.white.opacity(0.86))
                            .frame(width: 4.2, height: 4.2)
                            .offset(x: 2.2, y: 2)
                    }
            }
        }
        .frame(width: 20, height: 16)
    }

    private var cheek: some View {
        Circle()
            .fill(Color(red: 0.98, green: 0.46, blue: 0.43).opacity(0.36))
            .frame(width: 12, height: 8)
    }

    private var patch: some View {
        RoundedRectangle(cornerRadius: 3, style: .continuous)
            .fill(Color(red: 0.30, green: 0.22, blue: 0.16))
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
            .fill(Color.cyan.opacity(0.72))
            .frame(width: 7, height: 10)
            .scaleEffect(x: 0.76, anchor: .top)
    }

    private func scratch(width: CGFloat) -> some View {
        Capsule()
            .fill(Color.white.opacity(0.24))
            .frame(width: width, height: 2)
            .rotationEffect(.degrees(-12))
    }
}

private struct LifestyleBadge: View {
    let appearance: CharacterAppearance

    var body: some View {
        Image(systemName: appearance.badgeSymbolName)
            .font(.system(size: 22, weight: .bold))
            .symbolRenderingMode(.hierarchical)
            .foregroundStyle(appearance.tintColor)
            .padding(10)
            .background(Color(red: 1.0, green: 0.91, blue: 0.70).opacity(0.88), in: Circle())
            .overlay(Circle().stroke(appearance.woodColor.opacity(0.56), lineWidth: 1.6))
            .shadow(color: .black.opacity(0.18), radius: 8, y: 4)
    }
}

private struct TatamiFloor: View {
    let appearance: CharacterAppearance

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    appearance.floorColor.opacity(0.95),
                    appearance.floorColor.opacity(0.76)
                ],
                startPoint: .top,
                endPoint: .bottom
            )

            HStack(spacing: 0) {
                ForEach(0..<4, id: \.self) { index in
                    Rectangle()
                        .fill(index.isMultiple(of: 2) ? Color.white.opacity(0.08) : Color.black.opacity(0.05))
                        .overlay(alignment: .leading) {
                            Rectangle()
                                .fill(appearance.woodColor.opacity(0.28))
                                .frame(width: 2)
                        }
                }
            }

            VStack(spacing: 22) {
                ForEach(0..<3, id: \.self) { _ in
                    Rectangle()
                        .fill(appearance.woodColor.opacity(0.22))
                        .frame(height: 1.5)
                }
            }
        }
        .overlay(alignment: .top) {
            Rectangle()
                .fill(appearance.woodColor.opacity(0.46))
                .frame(height: 6)
        }
    }
}

private struct Shelf: View {
    let appearance: CharacterAppearance
    let isAmbientAnimating: Bool

    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 8) {
                Jar(color: appearance.propColor.opacity(0.75))
                    .frame(width: 17, height: 24)
                Jar(color: Color(red: 0.72, green: 0.47, blue: 0.25))
                    .frame(width: 15, height: 21)
                LeafShape()
                    .fill(Color(red: 0.28, green: 0.48, blue: 0.23))
                    .frame(width: 18, height: 24)
                    .rotationEffect(.degrees(isAmbientAnimating ? 7 : -5))
            }

            Rectangle()
                .fill(appearance.woodColor.opacity(0.86))
                .frame(height: 5)

            HStack(spacing: 5) {
                ForEach(0..<3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 3, style: .continuous)
                        .fill(index.isMultiple(of: 2) ? Color(red: 0.55, green: 0.36, blue: 0.22) : Color(red: 0.38, green: 0.24, blue: 0.16))
                        .frame(width: 14, height: 23)
                }
            }
        }
        .animation(.easeInOut(duration: 2.8).repeatForever(autoreverses: true), value: isAmbientAnimating)
    }
}

private struct LowTable: View {
    let appearance: CharacterAppearance

    var body: some View {
        ZStack(alignment: .top) {
            HStack(spacing: 60) {
                Capsule()
                    .fill(appearance.woodColor)
                    .frame(width: 10, height: 26)
                Capsule()
                    .fill(appearance.woodColor)
                    .frame(width: 10, height: 26)
            }
            .offset(y: 28)

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color(red: 0.58, green: 0.32, blue: 0.17))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color(red: 0.20, green: 0.12, blue: 0.08).opacity(0.75), lineWidth: 2)
                )
                .frame(height: 34)

            if appearance.clutterLevel >= 3 {
                MoyashiBowl(woodColor: appearance.woodColor)
                    .frame(width: 40, height: 28)
                    .offset(x: -18, y: 0)
            } else {
                HStack(spacing: 8) {
                    TeaCup(color: appearance.propColor)
                        .frame(width: 24, height: 24)
                    FeastPlate(color: appearance.tintColor)
                        .frame(width: 34, height: 24)
                }
                .offset(y: -5)
            }
        }
    }
}

private struct RoomClutterSymbols: View {
    let appearance: CharacterAppearance
    let isAmbientAnimating: Bool

    var body: some View {
        HStack(alignment: .bottom, spacing: 7) {
            ForEach(0..<appearance.clutterSymbols.count, id: \.self) { index in
                Image(systemName: appearance.clutterSymbols[index])
                    .font(.system(size: CGFloat(appearance.clutterLevel >= 3 ? 18 + index * 2 : 15 + index), weight: .bold))
                    .symbolRenderingMode(.hierarchical)
                    .foregroundStyle(index.isMultiple(of: 2) ? appearance.propColor : Color.white.opacity(0.72))
                    .rotationEffect(.degrees(isAmbientAnimating ? Double(index * 7 - 7) : Double(index * 5 - 11)))
                    .offset(y: isAmbientAnimating ? CGFloat(index % 2 == 0 ? -4 : 2) : CGFloat(index % 2 == 0 ? 2 : -3))
            }
        }
        .animation(.easeInOut(duration: 2.0).repeatForever(autoreverses: true), value: isAmbientAnimating)
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

private struct SpeechBubbleView: View {
    let text: String
    let appearance: CharacterAppearance

    var body: some View {
        Text(text)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(Color(red: 0.24, green: 0.13, blue: 0.08))
            .multilineTextAlignment(.center)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .background {
                SpeechBubbleShape()
                    .fill(Color(red: 1.0, green: 0.93, blue: 0.76))
                    .overlay(
                        SpeechBubbleShape()
                            .stroke(appearance.woodColor.opacity(0.54), lineWidth: 1.6)
                    )
                    .shadow(color: .black.opacity(0.12), radius: 10, y: 5)
            }
            .fixedSize(horizontal: false, vertical: true)
    }
}

private struct MountainRange: Shape {
    let peakOffset: CGFloat

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.midY + 24))
        path.addLine(to: CGPoint(x: rect.width * 0.25, y: rect.midY - 18 + peakOffset))
        path.addLine(to: CGPoint(x: rect.width * 0.48, y: rect.midY + 8))
        path.addLine(to: CGPoint(x: rect.width * 0.68, y: rect.midY - 28 - peakOffset * 0.4))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.midY + 16))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct VillagePath: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.width * 0.50, y: rect.minY))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.40, y: rect.maxY),
            control1: CGPoint(x: rect.width * 0.18, y: rect.height * 0.36),
            control2: CGPoint(x: rect.width * 0.76, y: rect.height * 0.62)
        )
        path.addLine(to: CGPoint(x: rect.width * 0.88, y: rect.maxY))
        path.addCurve(
            to: CGPoint(x: rect.width * 0.62, y: rect.minY),
            control1: CGPoint(x: rect.width * 0.95, y: rect.height * 0.60),
            control2: CGPoint(x: rect.width * 0.36, y: rect.height * 0.36)
        )
        path.closeSubpath()
        return path
    }
}

private struct MiniHouse: View {
    let roofColor: Color

    var body: some View {
        ZStack(alignment: .bottom) {
            Rectangle()
                .fill(Color(red: 0.74, green: 0.55, blue: 0.34))
                .overlay(Rectangle().stroke(Color(red: 0.24, green: 0.13, blue: 0.08), lineWidth: 1))
                .frame(width: 32, height: 24)

            Triangle()
                .fill(roofColor)
                .overlay(Triangle().stroke(Color(red: 0.24, green: 0.13, blue: 0.08), lineWidth: 1))
                .frame(width: 46, height: 28)
                .offset(y: -18)
        }
    }
}

private struct AutumnTree: View {
    let color: Color

    var body: some View {
        ZStack(alignment: .bottom) {
            Capsule()
                .fill(Color(red: 0.36, green: 0.20, blue: 0.12))
                .frame(width: 9, height: 64)

            ForEach(0..<9, id: \.self) { index in
                Circle()
                    .fill(index.isMultiple(of: 3) ? color.opacity(0.88) : color)
                    .frame(width: CGFloat(20 + (index % 3) * 6), height: CGFloat(17 + (index % 2) * 5))
                    .offset(x: CGFloat((index % 4) * 13 - 20), y: CGFloat(-52 - (index / 3) * 13))
            }
        }
    }
}

private struct ShojiWindow: View {
    let woodColor: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 6, style: .continuous)
            .fill(Color(red: 1.0, green: 0.91, blue: 0.70).opacity(0.72))
            .overlay(
                RoundedRectangle(cornerRadius: 6, style: .continuous)
                    .stroke(woodColor.opacity(0.86), lineWidth: 3)
            )
            .overlay {
                VStack(spacing: 0) {
                    ForEach(0..<4, id: \.self) { _ in
                        Rectangle()
                            .fill(woodColor.opacity(0.55))
                            .frame(height: 1.6)
                        Spacer()
                    }
                }
                HStack(spacing: 0) {
                    Rectangle()
                        .fill(woodColor.opacity(0.55))
                        .frame(width: 1.6)
                    Spacer()
                    Rectangle()
                        .fill(woodColor.opacity(0.55))
                        .frame(width: 1.6)
                }
                .padding(.horizontal, 17)
            }
    }
}

private struct CeilingBeams: View {
    let woodColor: Color

    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .fill(woodColor.opacity(0.86))
                .frame(height: 12)

            HStack(spacing: 28) {
                ForEach(0..<4, id: \.self) { index in
                    Rectangle()
                        .fill(woodColor.opacity(0.70))
                        .frame(width: 7, height: 58)
                        .rotationEffect(.degrees(Double(index - 2) * 7))
                }
            }
            .offset(y: 0)
        }
    }
}

private struct HangingClock: View {
    let woodColor: Color

    var body: some View {
        VStack(spacing: 2) {
            Circle()
                .fill(Color(red: 0.95, green: 0.83, blue: 0.62))
                .overlay(Circle().stroke(woodColor.opacity(0.88), lineWidth: 2))
                .overlay {
                    ClockHands()
                        .stroke(woodColor, style: StrokeStyle(lineWidth: 1.4, lineCap: .round))
                        .padding(8)
                }
                .frame(width: 28, height: 28)

            RoundedRectangle(cornerRadius: 4, style: .continuous)
                .fill(woodColor.opacity(0.86))
                .frame(width: 18, height: 22)
        }
    }
}

private struct ClockHands: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let center = CGPoint(x: rect.midX, y: rect.midY)
        path.move(to: center)
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY + 2))
        path.move(to: center)
        path.addLine(to: CGPoint(x: rect.maxX - 3, y: rect.midY + 4))
        return path
    }
}

private struct Cushion: View {
    let color: Color
    let woodColor: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(color)
            .overlay(RoundedRectangle(cornerRadius: 12, style: .continuous).stroke(woodColor.opacity(0.52), lineWidth: 1.6))
            .overlay {
                HStack(spacing: 6) {
                    ForEach(0..<3, id: \.self) { _ in
                        Circle()
                            .fill(.white.opacity(0.25))
                            .frame(width: 5, height: 5)
                    }
                }
            }
    }
}

private struct Futon: View {
    let color: Color
    let woodColor: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .fill(color)
            .overlay(RoundedRectangle(cornerRadius: 10, style: .continuous).stroke(woodColor.opacity(0.48), lineWidth: 1.4))
            .overlay(alignment: .topLeading) {
                Circle()
                    .fill(.white.opacity(0.28))
                    .frame(width: 11, height: 11)
                    .offset(x: 10, y: 8)
            }
    }
}

private struct TeaKettle: View {
    let woodColor: Color

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.28, green: 0.25, blue: 0.24))
                .overlay(Ellipse().stroke(woodColor.opacity(0.8), lineWidth: 1.4))
                .frame(width: 36, height: 24)
                .offset(y: 7)

            Circle()
                .stroke(woodColor.opacity(0.76), lineWidth: 2)
                .frame(width: 32, height: 25)
                .offset(y: -2)

            Rectangle()
                .fill(woodColor)
                .frame(width: 12, height: 6)
                .offset(y: -9)
        }
    }
}

private struct BareBulb: View {
    let appearance: CharacterAppearance

    var body: some View {
        VStack(spacing: 0) {
            Rectangle()
                .fill(appearance.woodColor.opacity(0.7))
                .frame(width: 2, height: 24)
            Image(systemName: "lightbulb.fill")
                .font(.system(size: 23, weight: .bold))
                .symbolRenderingMode(.hierarchical)
                .foregroundStyle(appearance.propColor)
                .shadow(color: appearance.propColor.opacity(0.44), radius: 8)
        }
    }
}

private struct CardboardBox: View {
    let woodColor: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 5, style: .continuous)
            .fill(Color(red: 0.58, green: 0.38, blue: 0.23))
            .overlay(RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(woodColor.opacity(0.72), lineWidth: 1.5))
            .overlay {
                VStack(spacing: 6) {
                    Rectangle().fill(woodColor.opacity(0.38)).frame(height: 1.2)
                    Rectangle().fill(woodColor.opacity(0.38)).frame(height: 1.2)
                }
                .padding(.horizontal, 8)
            }
    }
}

private struct TeaCup: View {
    let color: Color

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 6, style: .continuous)
                .fill(Color(red: 0.96, green: 0.92, blue: 0.80))
                .overlay(RoundedRectangle(cornerRadius: 6, style: .continuous).stroke(color.opacity(0.68), lineWidth: 1.3))
                .frame(width: 20, height: 16)
                .offset(y: 3)

            Ellipse()
                .fill(Color(red: 0.40, green: 0.65, blue: 0.36))
                .frame(width: 18, height: 6)
                .offset(y: -4)
        }
    }
}

private struct FeastPlate: View {
    let color: Color

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.95, green: 0.90, blue: 0.74))
                .overlay(Ellipse().stroke(color.opacity(0.6), lineWidth: 1.2))
                .frame(width: 32, height: 14)

            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .fill(index.isMultiple(of: 2) ? Color(red: 0.92, green: 0.37, blue: 0.22) : Color(red: 0.35, green: 0.62, blue: 0.30))
                    .frame(width: 8, height: 8)
                    .offset(x: CGFloat(index * 8 - 8), y: -2)
            }
        }
    }
}

private struct MoyashiBowl: View {
    let woodColor: Color

    var body: some View {
        ZStack {
            Ellipse()
                .fill(Color(red: 0.85, green: 0.78, blue: 0.62))
                .overlay(Ellipse().stroke(woodColor.opacity(0.76), lineWidth: 1.2))
                .frame(width: 36, height: 17)
                .offset(y: 6)

            ForEach(0..<5, id: \.self) { index in
                Capsule()
                    .fill(Color(red: 0.86, green: 0.88, blue: 0.66))
                    .frame(width: 3, height: 18)
                    .rotationEffect(.degrees(Double(index * 17 - 34)))
                    .offset(x: CGFloat(index * 5 - 10), y: -3)
            }
        }
    }
}

private struct Jar: View {
    let color: Color

    var body: some View {
        JarShape()
            .fill(color)
            .overlay(
                JarShape()
                    .stroke(Color(red: 0.24, green: 0.13, blue: 0.08).opacity(0.52), lineWidth: 1)
            )
    }
}

private struct JarShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX - rect.width * 0.20, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.midX + rect.width * 0.20, y: rect.minY))
        path.addCurve(
            to: CGPoint(x: rect.maxX, y: rect.maxY * 0.45),
            control1: CGPoint(x: rect.maxX * 0.72, y: rect.height * 0.10),
            control2: CGPoint(x: rect.maxX, y: rect.height * 0.22)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX, y: rect.maxY),
            control1: CGPoint(x: rect.maxX, y: rect.height * 0.82),
            control2: CGPoint(x: rect.maxX * 0.78, y: rect.maxY)
        )
        path.addCurve(
            to: CGPoint(x: rect.minX, y: rect.maxY * 0.45),
            control1: CGPoint(x: rect.maxX * 0.22, y: rect.maxY),
            control2: CGPoint(x: rect.minX, y: rect.height * 0.82)
        )
        path.addCurve(
            to: CGPoint(x: rect.midX - rect.width * 0.20, y: rect.minY),
            control1: CGPoint(x: rect.minX, y: rect.height * 0.22),
            control2: CGPoint(x: rect.maxX * 0.28, y: rect.height * 0.10)
        )
        path.closeSubpath()
        return path
    }
}

private struct SparkleCluster: View {
    let color: Color

    var body: some View {
        ZStack {
            ForEach(0..<5, id: \.self) { index in
                Image(systemName: "sparkle")
                    .font(.system(size: CGFloat(10 + index), weight: .bold))
                    .foregroundStyle(color.opacity(0.7))
                    .offset(x: CGFloat(index * 18 - 32), y: CGFloat((index % 3) * 15 - 18))
            }
        }
    }
}

private struct SketchTexture: View {
    let color: Color

    var body: some View {
        ZStack {
            ForEach(0..<12, id: \.self) { index in
                Capsule()
                    .fill(color.opacity(0.35))
                    .frame(width: CGFloat(80 + (index % 4) * 38), height: 1)
                    .rotationEffect(.degrees(Double(index * 7 - 18)))
                    .offset(x: CGFloat((index % 5) * 58 - 118), y: CGFloat(index * 24 - 132))
            }
        }
    }
}

private struct DimRoomOverlay: View {
    var body: some View {
        LinearGradient(
            colors: [
                Color.black.opacity(0.18),
                Color.black.opacity(0.38)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }
}

private struct MouthShape: Shape {
    let style: TanukiMouthStyle

    func path(in rect: CGRect) -> Path {
        var path = Path()
        switch style {
        case .grandSmile:
            path.move(to: CGPoint(x: rect.minX + 4, y: rect.midY - 2))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY - 2), control: CGPoint(x: rect.midX - 1, y: rect.maxY + 5))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - 4, y: rect.midY - 2), control: CGPoint(x: rect.midX + 1, y: rect.maxY + 5))
        case .softSmile:
            path.move(to: CGPoint(x: rect.minX + 5, y: rect.midY))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - 5, y: rect.midY), control: CGPoint(x: rect.midX, y: rect.maxY - 1))
        case .pleased:
            path.move(to: CGPoint(x: rect.minX + 5, y: rect.midY + 1))
            path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY + 7), control: CGPoint(x: rect.midX - 2, y: rect.maxY + 2))
            path.move(to: CGPoint(x: rect.midX, y: rect.midY + 7))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - 5, y: rect.midY + 1), control: CGPoint(x: rect.midX + 2, y: rect.maxY + 2))
        case .calm:
            path.move(to: CGPoint(x: rect.minX + 7, y: rect.midY + 3))
            path.addLine(to: CGPoint(x: rect.maxX - 7, y: rect.midY + 3))
        case .worried:
            path.move(to: CGPoint(x: rect.minX + 7, y: rect.midY + 5))
            path.addQuadCurve(to: CGPoint(x: rect.maxX - 7, y: rect.midY + 5), control: CGPoint(x: rect.midX, y: rect.midY - 4))
        case .resigned:
            path.move(to: CGPoint(x: rect.minX + 8, y: rect.midY + 4))
            path.addLine(to: CGPoint(x: rect.maxX - 8, y: rect.midY + 4))
            path.move(to: CGPoint(x: rect.midX - 2, y: rect.midY + 10))
            path.addLine(to: CGPoint(x: rect.midX + 2, y: rect.midY + 10))
        }
        return path
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

private struct FaceMask: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY + 6), control: CGPoint(x: rect.midX, y: rect.minY - 4))
        path.addQuadCurve(to: CGPoint(x: rect.maxX - 4, y: rect.maxY), control: CGPoint(x: rect.maxX + 1, y: rect.midY + 8))
        path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.midY), control: CGPoint(x: rect.midX - 6, y: rect.maxY + 1))
        path.closeSubpath()
        return path
    }
}

private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

private struct LeafShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.maxY), control: CGPoint(x: rect.maxX + 2, y: rect.midY))
        path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.minY), control: CGPoint(x: rect.minX - 2, y: rect.midY))
        return path
    }
}

private struct SpeechBubbleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let tailWidth: CGFloat = 14
        let tailHeight: CGFloat = 9
        let bubbleRect = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: rect.height - tailHeight)
        var path = RoundedRectangle(cornerRadius: 16, style: .continuous).path(in: bubbleRect)
        path.move(to: CGPoint(x: rect.midX - tailWidth * 0.5, y: bubbleRect.maxY - 1))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX + tailWidth * 0.5, y: bubbleRect.maxY - 1))
        path.closeSubpath()
        return path
    }
}

#Preview("Grand rich") {
    CharacterView(level: .grandRich, line: "今夜はドンペリでも開けるかね")
        .padding()
}

#Preview("Broke") {
    CharacterView(level: .broke, line: "今月の財布、薄いのう...")
        .padding()
}

#Preview("Extreme poor") {
    CharacterView(level: .extremePoor, line: "もやし、うまい...")
        .padding()
}
