import SwiftUI

struct XPBar: View {
    let xp: Int

    private var rank: Rank { Rank.from(xp: xp) }
    private var next: Rank? { rank.next }
    private var progress: Double {
        guard let next else { return 1 }
        let span = Double(next.minXP - rank.minXP)
        guard span > 0 else { return 1 }
        return min(1, Double(xp - rank.minXP) / span)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(rank.rawValue.uppercased())
                    .font(.system(size: 12, weight: .heavy))
                    .foregroundStyle(rank.accent)
                Spacer()
                if let next {
                    Text("\(xp) / \(next.minXP) XP")
                        .font(EVTheme.hud)
                        .foregroundStyle(EVTheme.mist)
                } else {
                    Text("\(xp) XP · MAX")
                        .font(EVTheme.hud)
                        .foregroundStyle(EVTheme.acid)
                }
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule().fill(EVTheme.line.opacity(0.8))
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [rank.accent, EVTheme.acid],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .frame(width: geo.size.width * progress)
                        .shadow(color: EVTheme.acid.opacity(0.35), radius: 8)
                }
            }
            .frame(height: 8)
        }
    }
}
