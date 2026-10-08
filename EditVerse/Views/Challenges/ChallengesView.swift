import SwiftUI

struct ChallengesView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    Text("Weekly arenas")
                        .font(.system(size: 32, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)
                    Text("Massive Gamification startet hier: Brief, Deadline, XP-Preis.")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundStyle(EVTheme.mist)

                    ForEach(appState.challenges) { challenge in
                        ChallengeCard(challenge: challenge)
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

struct ChallengeCard: View {
    let challenge: Challenge

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text(challenge.difficulty.rawValue.uppercased())
                    .font(.system(size: 11, weight: .heavy))
                    .foregroundStyle(EVTheme.ink)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(difficultyColor)
                    .clipShape(Capsule())
                Spacer()
                Text("\(challenge.endsInHours)h left")
                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                    .foregroundStyle(EVTheme.mist)
            }

            Text(challenge.title)
                .font(.system(size: 24, weight: .black, design: .rounded))
                .foregroundStyle(EVTheme.paper)

            Text(challenge.brief)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(EVTheme.mist)

            HStack {
                Label(challenge.tag.rawValue, systemImage: "tag")
                Spacer()
                Label("\(challenge.entrants)", systemImage: "person.3")
                Spacer()
                Text("+\(challenge.prizeXP) XP")
                    .font(.system(size: 13, weight: .heavy, design: .monospaced))
                    .foregroundStyle(EVTheme.acid)
            }
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(EVTheme.mist)
        }
        .padding(16)
        .background(EVTheme.panel)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(EVTheme.line, lineWidth: 1)
        )
    }

    private var difficultyColor: Color {
        switch challenge.difficulty {
        case .easy: EVTheme.acid
        case .hard: EVTheme.heat
        case .legend: Color(hex: 0xFFD166)
        }
    }
}
