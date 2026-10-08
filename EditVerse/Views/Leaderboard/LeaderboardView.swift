import SwiftUI

struct LeaderboardView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            EVTheme.void.ignoresSafeArea()
            LinearGradient(
                colors: [EVTheme.acid.opacity(0.18), .clear, Color(hex: 0xFFD166).opacity(0.12)],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 18) {
                    Text("EDITVERSE")
                        .font(.system(size: 12, weight: .black))
                        .tracking(3)
                        .foregroundStyle(EVTheme.acid)
                    Text("LADDER")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)
                    Text("Season XP. Climb or get cut.")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    ForEach(appState.leaderboard) { entry in
                        HStack(spacing: 14) {
                            Text("#\(entry.place)")
                                .font(.system(size: 20, weight: .black, design: .monospaced))
                                .foregroundStyle(entry.place <= 3 ? EVTheme.acid : EVTheme.mist)
                                .frame(width: 48, alignment: .leading)

                            Circle()
                                .fill(Color(hue: entry.creator.avatarHue, saturation: 0.55, brightness: 0.88))
                                .frame(width: 44, height: 44)
                                .overlay { Circle().strokeBorder(.white.opacity(0.35), lineWidth: 1) }

                            VStack(alignment: .leading, spacing: 3) {
                                Text(entry.creator.displayName)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(EVTheme.paper)
                                Text(entry.creator.rank.rawValue)
                                    .font(.system(size: 12, weight: .heavy))
                                    .foregroundStyle(entry.creator.rank.accent)
                            }

                            Spacer()

                            Text("\(entry.creator.xp)")
                                .font(.system(size: 16, weight: .black, design: .monospaced))
                                .foregroundStyle(EVTheme.paper)
                        }
                        .padding(16)
                        .background {
                            LiquidGlassBackground(
                                cornerRadius: 22,
                                intensity: entry.creator.id == appState.me.id ? 1.15 : 0.9
                            )
                        }
                        .overlay {
                            if entry.creator.id == appState.me.id {
                                RoundedRectangle(cornerRadius: 22, style: .continuous)
                                    .strokeBorder(EVTheme.acid.opacity(0.45), lineWidth: 1.2)
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
}
