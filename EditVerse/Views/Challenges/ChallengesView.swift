import SwiftUI

struct ChallengesView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        ZStack {
            atmosphere
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 22) {
                    Text("EDITVERSE")
                        .font(.system(size: 12, weight: .black))
                        .tracking(3)
                        .foregroundStyle(EVTheme.acid)
                    Text("ARENA")
                        .font(.system(size: 48, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)
                    Text("Weekly briefs. Drop cuts. Climb the season.")
                        .font(.system(size: 15, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    ForEach(appState.challenges) { challenge in
                        ArenaStage(challenge: challenge)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.top, 64)
                .padding(.bottom, 120)
            }
        }
    }

    private var atmosphere: some View {
        ZStack {
            EVTheme.void
            LinearGradient(
                colors: [EVTheme.heat.opacity(0.28), .clear, EVTheme.acid.opacity(0.12)],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        }
        .ignoresSafeArea()
    }
}

struct ArenaStage: View {
    let challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                Text(challenge.difficulty.rawValue.uppercased())
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(EVTheme.ink)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                    .background(difficultyColor)
                    .clipShape(Capsule())
                Spacer()
                Text("\(challenge.endsInHours)h")
                    .font(EVTheme.hud)
                    .foregroundStyle(EVTheme.paper)
            }

            Text(challenge.title)
                .font(.system(size: 30, weight: .black, design: .rounded))
                .foregroundStyle(EVTheme.paper)

            Text(challenge.brief)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(EVTheme.mist)

            HStack {
                Text(challenge.tag.rawValue)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(EVTheme.paper)
                Spacer()
                Text("\(challenge.entrants) in")
                    .font(EVTheme.hud)
                    .foregroundStyle(EVTheme.mist)
                Text("+\(challenge.prizeXP) XP")
                    .font(.system(size: 13, weight: .heavy, design: .monospaced))
                    .foregroundStyle(EVTheme.acid)
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background {
            LiquidGlassBackground(cornerRadius: 30, intensity: 1)
        }
    }

    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: EVTheme.acid
        case .hard: EVTheme.heat
        case .legend: Color(hex: 0xFFD166)
        }
    }
}
