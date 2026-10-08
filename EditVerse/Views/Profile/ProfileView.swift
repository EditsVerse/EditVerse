import SwiftUI

struct ProfileView: View {
    @Environment(AppState.self) private var appState
    let creator: Creator
    var isMe: Bool = false

    private var resolved: Creator {
        isMe ? appState.me : creator
    }

    private var myPosts: [EditPost] {
        appState.posts.filter { $0.creatorId == resolved.id }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    HStack(spacing: 14) {
                        Circle()
                            .fill(Color(hue: resolved.avatarHue, saturation: 0.55, brightness: 0.85))
                            .frame(width: 72, height: 72)
                            .overlay {
                                Text(String(resolved.displayName.prefix(1)))
                                    .font(.system(size: 28, weight: .black))
                                    .foregroundStyle(.black)
                            }

                        VStack(alignment: .leading, spacing: 4) {
                            Text(resolved.displayName)
                                .font(.system(size: 26, weight: .black, design: .rounded))
                                .foregroundStyle(EVTheme.paper)
                            Text("@\(resolved.handle)")
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundStyle(EVTheme.mist)
                            Text(resolved.rank.rawValue)
                                .font(.system(size: 13, weight: .heavy))
                                .foregroundStyle(resolved.rank.accent)
                        }
                    }

                    Text(resolved.bio)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    XPBar(xp: resolved.xp)

                    HStack {
                        stat("Edits", "\(resolved.editsCount)")
                        stat("Followers", compact(resolved.followers))
                        stat("Streak", "\(resolved.streak)d")
                    }

                    Text("Achievements")
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(EVTheme.paper)

                    ForEach(isMe ? appState.achievements : MockData.achievements) { item in
                        HStack {
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
                                    .font(.system(size: 12, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(EVTheme.mist)
                            }
                        }
                        .padding(12)
                        .background(EVTheme.panel)
                        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    }

                    Text("Edits")
                        .font(.system(size: 18, weight: .black))
                        .foregroundStyle(EVTheme.paper)

                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) {
                        ForEach(myPosts) { post in
                            EditPoster(
                                colors: post.posterColors,
                                title: post.title,
                                beatDropAt: post.beatDropAt,
                                compact: true
                            )
                            .frame(height: 160)
                        }
                    }
                }
                .padding(16)
                .padding(.bottom, 28)
            }
            .background(EVTheme.ink.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    private func stat(_ label: String, _ value: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 18, weight: .black, design: .monospaced))
                .foregroundStyle(EVTheme.paper)
            Text(label)
                .font(.system(size: 11, weight: .bold))
                .foregroundStyle(EVTheme.mist)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(EVTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }

    private func compact(_ value: Int) -> String {
        if value >= 1_000 { return String(format: "%.1fK", Double(value) / 1_000) }
        return "\(value)"
    }
}
