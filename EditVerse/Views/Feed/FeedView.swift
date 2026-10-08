import SwiftUI

struct FeedView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 22) {
                    header
                    ForEach(appState.posts) { post in
                        EditCard(post: post)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(EVTheme.ink.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("EditVerse")
                        .font(.system(size: 20, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)
                }
            }
            .toolbarBackground(EVTheme.ink, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("CUT. DROP. FLEX.")
                .font(.system(size: 34, weight: .black, design: .rounded))
                .foregroundStyle(EVTheme.paper)
            Text("Der Feed nur für fertige Edits — mit XP, Challenges und Ranks.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(EVTheme.mist)
            XPBar(xp: appState.me.xp)
                .padding(.top, 4)
        }
        .padding(.top, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

struct EditCard: View {
    @Environment(AppState.self) private var appState
    let post: EditPost

    private var creator: Creator { appState.creator(for: post.creatorId) }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                Circle()
                    .fill(Color(hue: creator.avatarHue, saturation: 0.55, brightness: 0.85))
                    .frame(width: 36, height: 36)
                    .overlay {
                        Text(String(creator.displayName.prefix(1)))
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.black)
                    }
                VStack(alignment: .leading, spacing: 2) {
                    Text(creator.displayName)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(EVTheme.paper)
                    Text("@\(creator.handle) · \(creator.rank.rawValue)")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(EVTheme.mist)
                }
                Spacer()
                Text("+\(post.xpAwarded) XP")
                    .font(.system(size: 11, weight: .heavy, design: .monospaced))
                    .foregroundStyle(EVTheme.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(EVTheme.acid)
                    .clipShape(Capsule())
            }

            EditPoster(
                colors: post.posterColors,
                title: post.title,
                beatDropAt: post.beatDropAt
            )
            .frame(height: 360)
            .overlay(alignment: .bottomTrailing) {
                Text(formatDuration(post.durationSec))
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(EVTheme.paper)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(.black.opacity(0.55))
                    .clipShape(RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .padding(14)
            }

            Text(post.caption)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(EVTheme.mist)

            FlowTags(tags: post.tags)

            HStack(spacing: 18) {
                actionButton(
                    system: post.likedByMe ? "heart.fill" : "heart",
                    label: compact(post.likes),
                    tint: post.likedByMe ? EVTheme.heat : EVTheme.paper
                ) {
                    appState.toggleLike(post)
                }
                actionButton(system: "bubble.right", label: compact(post.comments), tint: EVTheme.paper) {}
                actionButton(
                    system: post.savedByMe ? "bookmark.fill" : "bookmark",
                    label: compact(post.saves),
                    tint: post.savedByMe ? EVTheme.acid : EVTheme.paper
                ) {
                    appState.toggleSave(post)
                }
                Spacer()
                Text(compact(post.views) + " views")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .foregroundStyle(EVTheme.mist)
            }
        }
        .padding(14)
        .background(EVTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 26, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .stroke(EVTheme.line, lineWidth: 1)
        )
    }

    private func actionButton(system: String, label: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: system)
                Text(label)
                    .font(.system(size: 13, weight: .semibold, design: .monospaced))
            }
            .foregroundStyle(tint)
        }
        .buttonStyle(.plain)
    }

    private func compact(_ value: Int) -> String {
        if value >= 1_000_000 { return String(format: "%.1fM", Double(value) / 1_000_000) }
        if value >= 1_000 { return String(format: "%.1fK", Double(value) / 1_000) }
        return "\(value)"
    }

    private func formatDuration(_ seconds: Int) -> String {
        String(format: "%d:%02d", seconds / 60, seconds % 60)
    }
}

struct FlowTags: View {
    let tags: [EditTag]

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(tags) { tag in
                    Text(tag.rawValue)
                        .font(.system(size: 11, weight: .bold))
                        .foregroundStyle(EVTheme.paper)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 6)
                        .background(EVTheme.line.opacity(0.7))
                        .clipShape(Capsule())
                }
            }
        }
    }
}
