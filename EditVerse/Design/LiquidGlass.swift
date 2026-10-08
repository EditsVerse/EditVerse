import SwiftUI

/// EditVerse Liquid Glass — compiles on older SDKs, reads like iOS Liquid Glass.
struct LiquidGlassBackground: View {
    var cornerRadius: CGFloat = 28
    var intensity: Double = 1

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            .fill(.ultraThinMaterial)
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .fill(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.28 * intensity),
                                .white.opacity(0.04 * intensity),
                                EVTheme.acid.opacity(0.08 * intensity),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .blendMode(.screen)
            }
            .overlay {
                RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                    .strokeBorder(
                        LinearGradient(
                            colors: [
                                .white.opacity(0.55 * intensity),
                                .white.opacity(0.08 * intensity),
                                EVTheme.acid.opacity(0.25 * intensity),
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        ),
                        lineWidth: 1
                    )
            }
            .shadow(color: .black.opacity(0.35), radius: 18, y: 8)
    }
}

struct GlassCapsuleBackground: View {
    var body: some View {
        Capsule()
            .fill(.ultraThinMaterial)
            .overlay {
                Capsule()
                    .fill(
                        LinearGradient(
                            colors: [.white.opacity(0.3), .clear, EVTheme.acid.opacity(0.12)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .overlay {
                Capsule()
                    .strokeBorder(
                        LinearGradient(
                            colors: [.white.opacity(0.5), .white.opacity(0.08)],
                            startPoint: .top,
                            endPoint: .bottom
                        ),
                        lineWidth: 1
                    )
            }
    }
}

struct GlassIconButton: View {
    let systemName: String
    var filled: Bool = false
    var tint: Color = EVTheme.paper
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 20, weight: .bold))
                .foregroundStyle(filled ? tint : EVTheme.paper)
                .frame(width: 54, height: 54)
                .background {
                    Circle()
                        .fill(.ultraThinMaterial)
                        .overlay {
                            Circle().strokeBorder(.white.opacity(0.35), lineWidth: 1)
                        }
                        .shadow(color: (filled ? tint : .black).opacity(filled ? 0.45 : 0.25), radius: 12, y: 4)
                }
        }
        .buttonStyle(.plain)
    }
}

struct SheenOverlay: View {
    var body: some View {
        TimelineView(.animation(minimumInterval: 1 / 24)) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate
            let shift = CGFloat((sin(t * 0.35) + 1) * 0.5)
            LinearGradient(
                colors: [
                    .clear,
                    .white.opacity(0.08),
                    .clear,
                ],
                startPoint: UnitPoint(x: shift - 0.3, y: 0),
                endPoint: UnitPoint(x: shift + 0.3, y: 1)
            )
            .allowsHitTesting(false)
        }
    }
}
