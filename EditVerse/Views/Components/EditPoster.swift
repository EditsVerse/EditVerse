import SwiftUI

struct EditPoster: View {
    let colors: [Color]
    let title: String
    let beatDropAt: Double
    var compact: Bool = false

    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 30)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let pulse = 0.5 + 0.5 * sin(t * 2.2)

            ZStack {
                LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)

                // Timeline rail
                VStack {
                    Spacer()
                    ZStack(alignment: .leading) {
                        Capsule().fill(.white.opacity(0.15)).frame(height: 4)
                        Capsule()
                            .fill(EVTheme.acid)
                            .frame(width: max(24, beatDropAt * (compact ? 160 : 280)), height: 4)
                        Circle()
                            .fill(EVTheme.paper)
                            .frame(width: 10, height: 10)
                            .scaleEffect(1 + 0.15 * pulse)
                            .offset(x: beatDropAt * (compact ? 160 : 280) - 5)
                    }
                    .padding(.horizontal, compact ? 14 : 20)
                    .padding(.bottom, compact ? 14 : 22)
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("EDITVERSE")
                        .font(.system(size: compact ? 10 : 12, weight: .heavy, design: .default))
                        .tracking(3)
                        .foregroundStyle(EVTheme.acid)
                    Spacer()
                    Text(title)
                        .font(.system(size: compact ? 22 : 34, weight: .black, design: .rounded))
                        .foregroundStyle(EVTheme.paper)
                        .lineLimit(3)
                        .minimumScaleFactor(0.8)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding(compact ? 14 : 22)

                // Scan texture
                Rectangle()
                    .fill(
                        LinearGradient(
                            colors: [.clear, .white.opacity(0.05), .clear],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .opacity(0.7 + 0.3 * pulse)
                    .allowsHitTesting(false)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: compact ? 18 : 28, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: compact ? 18 : 28, style: .continuous)
                .stroke(EVTheme.line.opacity(0.8), lineWidth: 1)
        )
    }
}
