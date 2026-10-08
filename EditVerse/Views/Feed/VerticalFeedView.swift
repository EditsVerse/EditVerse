import SwiftUI

struct VerticalFeedView: View {
    @Environment(AppState.self) private var appState
    @State private var currentID: String?

    var body: some View {
        ZStack {
            EVTheme.void.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(appState.posts) { post in
                        EditStage(post: post)
                            .containerRelativeFrame([.horizontal, .vertical])
                            .id(post.id)
                    }
                }
                .scrollTargetLayout()
            }
            .scrollTargetBehavior(.paging)
            .scrollPosition(id: $currentID)
            .ignoresSafeArea()

            // Brand watermark — hero signal, not nav crumb
            VStack {
                HStack {
                    Text("EDITVERSE")
                        .font(.system(size: 14, weight: .black, design: .rounded))
                        .tracking(4)
                        .foregroundStyle(EVTheme.paper)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 8)
                        .background { GlassCapsuleBackground() }
                    Spacer()
                    XPOrb(xp: appState.me.xp, rank: appState.me.rank)
                }
                .padding(.horizontal, 16)
                .padding(.top, 56)
                Spacer()
            }
            .allowsHitTesting(true)
        }
        .onAppear {
            currentID = appState.posts.first?.id
        }
    }
}

struct XPOrb: View {
    let xp: Int
    let rank: Rank

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 20)) { timeline in
            let pulse = 1 + 0.03 * sin(timeline.date.timeIntervalSinceReferenceDate * 3)
            HStack(spacing: 8) {
                Circle()
                    .fill(rank.accent)
                    .frame(width: 8, height: 8)
                    .shadow(color: rank.accent.opacity(0.8), radius: 6)
                VStack(alignment: .leading, spacing: 1) {
                    Text(rank.rawValue.uppercased())
                        .font(.system(size: 9, weight: .heavy))
                        .foregroundStyle(rank.accent)
                    Text("\(xp) XP")
                        .font(EVTheme.hud)
                        .foregroundStyle(EVTheme.paper)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background { GlassCapsuleBackground() }
            .scaleEffect(pulse)
        }
    }
}

struct EditStage: View {
    @Environment(AppState.self) private var appState
    let post: EditPost

    private var creator: Creator { appState.creator(for: post.creatorId) }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                // Full-bleed visual plane — NOT a card
                EditCanvas(
                    colors: post.posterColors,
                    title: post.title,
                    beatDropAt: post.beatDropAt,
                    size: geo.size
                )
                .ignoresSafeArea()

                // Vertical vignette for readability
                LinearGradient(
                    colors: [
                        .black.opacity(0.55),
                        .clear,
                        .clear,
                        .black.opacity(0.72),
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                .allowsHitTesting(false)

                SheenOverlay()
                    .ignoresSafeArea()

                // Right action rail
                HStack(alignment: .bottom) {
                    Spacer()
                    VStack(spacing: 16) {
                        creatorOrb
                        GlassIconButton(
                            systemName: post.likedByMe ? "heart.fill" : "heart",
                            filled: post.likedByMe,
                            tint: EVTheme.heat
                        ) {
                            appState.toggleLike(post)
                        }
                        meta(compact(post.likes))

                        GlassIconButton(
                            systemName: post.savedByMe ? "bookmark.fill" : "bookmark",
                            filled: post.savedByMe,
                            tint: EVTheme.acid
                        ) {
                            appState.toggleSave(post)
                        }
                        meta(compact(post.saves))

                        GlassIconButton(systemName: "bubble.right") {}
                        meta(compact(post.comments))
                    }
                    .padding(.trailing, 14)
                    .padding(.bottom, 118)
                }

                // Bottom identity / caption HUD
                VStack {
                    Spacer()
                    HStack(alignment: .bottom) {
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 8) {
                                Text("@\(creator.handle)")
                                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                                    .foregroundStyle(EVTheme.paper)
                                Text(creator.rank.rawValue)
                                    .font(.system(size: 11, weight: .heavy))
                                    .foregroundStyle(EVTheme.ink)
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(creator.rank.accent)
                                    .clipShape(Capsule())
                            }

                            Text(post.title)
                                .font(.system(size: 28, weight: .black, design: .rounded))
                                .foregroundStyle(EVTheme.paper)
                                .lineLimit(2)

                            Text(post.caption)
                                .font(.system(size: 14, weight: .medium))
                                .foregroundStyle(EVTheme.paper.opacity(0.82))
                                .lineLimit(2)

                            HStack(spacing: 8) {
                                ForEach(post.tags.prefix(3)) { tag in
                                    Text(tag.rawValue)
                                        .font(.system(size: 11, weight: .bold))
                                        .foregroundStyle(EVTheme.paper)
                                        .padding(.horizontal, 10)
                                        .padding(.vertical, 6)
                                        .background { GlassCapsuleBackground() }
                                }
                                Text(timecode(post.durationSec))
                                    .font(EVTheme.hud)
                                    .foregroundStyle(EVTheme.acid)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background { GlassCapsuleBackground() }
                            }
                        }
                        .padding(.leading, 16)
                        .padding(.trailing, 86)
                        .padding(.bottom, 112)
                        Spacer(minLength: 0)
                    }
                }
            }
        }
    }

    private var creatorOrb: some View {
        Circle()
            .fill(Color(hue: creator.avatarHue, saturation: 0.55, brightness: 0.9))
            .frame(width: 54, height: 54)
            .overlay {
                Text(String(creator.displayName.prefix(1)))
                    .font(.system(size: 20, weight: .black))
                    .foregroundStyle(.black)
            }
            .overlay {
                Circle().strokeBorder(.white.opacity(0.45), lineWidth: 1.2)
            }
            .shadow(color: .black.opacity(0.35), radius: 10, y: 4)
    }

    private func meta(_ text: String) -> some View {
        Text(text)
            .font(EVTheme.hud)
            .foregroundStyle(EVTheme.paper)
            .shadow(color: .black.opacity(0.6), radius: 4, y: 1)
    }

    private func compact(_ value: Int) -> String {
        if value >= 1_000_000 { return String(format: "%.1fM", Double(value) / 1_000_000) }
        if value >= 1_000 { return String(format: "%.1fK", Double(value) / 1_000) }
        return "\(value)"
    }

    private func timecode(_ seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}

struct EditCanvas: View {
    let colors: [Color]
    let title: String
    let beatDropAt: Double
    let size: CGSize

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let breath = 1.02 + 0.02 * sin(t * 0.8)

            ZStack {
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
                    .scaleEffect(breath)

                // Timeline energy — cinema, not UI chrome
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.12)).frame(height: 3)
                        Capsule()
                            .fill(EVTheme.acid)
                            .frame(width: max(20, size.width * beatDropAt * 0.72), height: 3)
                        Circle()
                            .fill(EVTheme.paper)
                            .frame(width: 11, height: 11)
                            .offset(x: size.width * beatDropAt * 0.72 - 5)
                            .shadow(color: EVTheme.acid.opacity(0.7), radius: 8)
                    }
                    .padding(.horizontal, 28)
                    .padding(.bottom, size.height * 0.34)
                }

                // Giant brand cut mark
                Text("CUT")
                    .font(.system(size: min(size.width * 0.42, 180), weight: .black, design: .rounded))
                    .foregroundStyle(.white.opacity(0.06))
                    .rotationEffect(.degrees(-12))
                    .offset(y: -size.height * 0.08)
            }
        }
    }
}
