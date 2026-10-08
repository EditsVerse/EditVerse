import SwiftUI

struct LeaderboardView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Global ranks")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)
                    Text("XP diese Season. Climb or get cut.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    ForEach(appState.leaderboard) { entry in
                        HStack(spacing: 12) {
                            Text("#\(entry.place)")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundStyle(entry.place <= 3 ? EVTheme.acid : EVTheme.mist)
                                .frame(width: 44, alignment: .leading)

                            Circle()
                                .fill(Color(hue: entry.creator.avatarHue, saturation: 0.55, brightness: 0.85))
                                .frame(width: 40, height: 40)

                            VStack(alignment: .leading, spacing: 2) {
                                Text(entry.creator.displayName)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(EVTheme.paper)
                                Text(entry.creator.rank.rawValue)
                                    .font(.system(size: 12, weight: .semibold))
                                    .foregroundStyle(entry.creator.rank.accent)
                            }

                            Spacer()

                            VStack(alignment: .trailing, spacing: 2) {
                                Text("\(entry.creator.xp)")
                                    .font(.system(size: 14, weight: .heavy, design: .monospaced))
                                    .foregroundStyle(EVTheme.paper)
                                Text("XP")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundStyle(EVTheme.mist)
                            }
                        }
                        .padding(14)
                        .background(entry.creator.id == appState.me.id ? EVTheme.acid.opacity(0.12) : EVTheme.panel)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18, style: .continuous)
                                .stroke(entry.creator.id == appState.me.id ? EVTheme.acid.opacity(0.5) : EVTheme.line, lineWidth: 1)
                        )
                    }
                }
                .padding(16)
                .padding(.bottom, 28)
            }
            .background(EVTheme.ink.ignoresSafeArea())
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
