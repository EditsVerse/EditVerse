import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    let creator: Creator
    var isMe: Bool = false

    private var resolved: Creator { isMe ? appState.me : creator }

    private var myPosts: [EditPost] {
        appState.posts.filter { $0.creatorId == resolved.id }
    }

    var body: some View {
        ZStack {
            EVTheme.void.ignoresSafeArea()
            LinearGradient(
                colors: [Color(hue: resolved.avatarHue, saturation: 0.45, brightness: 0.35).opacity(0.55), .clear],
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    Text("EDITVERSE")
                        .font(.system(size: 12, weight: .black))
                        .tracking(3)
                        .foregroundStyle(EVTheme.acid)

                    HStack(spacing: 16) {
                        Circle()
                            .fill(Color(hue: resolved.avatarHue, saturation: 0.55, brightness: 0.9))
                            .frame(width: 84, height: 84)
                            .overlay {
                                Text(String(resolved.displayName.prefix(1)))
                                    .font(.system(size: 32, weight: .black))
                                    .foregroundStyle(.black)
                            }
                            .overlay { Circle().strokeBorder(.white.opacity(0.4), lineWidth: 1.2) }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(resolved.displayName)
                                .font(.system(size: 30, weight: .black, design: .rounded))
                                .foregroundStyle(EVTheme.paper)
                            Text("@\(resolved.handle)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(EVTheme.mist)
                            Text(resolved.rank.rawValue.uppercased())
                                .font(.system(size: 12, weight: .heavy))
                                .foregroundStyle(resolved.rank.accent)
                        }
                    }

                    Text(resolved.bio)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    XPBar(xp: resolved.xp)
                        .padding(16)
                        .background { LiquidGlassBackground(cornerRadius: 22, intensity: 0.95) }

                    HStack(spacing: 10) {
                        glassStat("Edits", "\(resolved.editsCount)")
                        glassStat("Followers", compact(resolved.followers))
                        glassStat("Streak", "\(resolved.streak)d")
                    }

                    Text("Achievements")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)

                    ForEach(isMe ? appState.achievements : MockData.achievements) { item in
                        HStack(spacing: 12) {
                            Image(systemName: item.unlocked ? "checkmark.seal.fill" : "lock.fill")
                                .foregroundStyle(item.unlocked ? EVTheme.acid : EVTheme.mist)
                            VStack(alignment: .leading, spacing: 2) {
                                Text(item.title)
                                    .font(.system(size: 14, weight: .bold))
                                    .foregroundStyle(EVTheme.paper)
                                Text(item.detail)
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(EVTheme.mist)
                            }
                            Spacer()
                            if item.xp > 0 {
                                Text("+\(item.xp)")
                                    .font(EVTheme.hud)
                                    .foregroundStyle(EVTheme.mist)
                            }
                        }
                        .padding(14)
                        .background { LiquidGlassBackground(cornerRadius: 18, intensity: 0.85) }
                    }

                    Text("Reel")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)

                    LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                        ForEach(myPosts) { post in
                            EditCanvas(
                                colors: post.posterColors,
                                title: post.title,
                                beatDropAt: post.beatDropAt,
                                size: CGSize(width: 170, height: 220)
                            )
                            .frame(height: 220)
                            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
                            .overlay {
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .strokeBorder(.white.opacity(0.2), lineWidth: 1)
                            }
                        }
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 64)
                .padding(.bottom, 120)
            }
        }
    }

    private func glassStat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .black, design: .monospaced))
                .foregroundStyle(EVTheme.paper)
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(EVTheme.mist)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 14)
        .background { LiquidGlassBackground(cornerRadius: 18, intensity: 0.85) }
    }

    private func compact(_ value: Int) -> String {
        if value >= 1_000 { return String(format: "%.1fK", Double(value) / 1_000) }
        return "\(value)"
    }
}
