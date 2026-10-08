import SwiftUI

struct AppShell: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        ZStack(alignment: .bottom) {
            EVTheme.void.ignoresSafeArea()

            Group {
                switch appState.selectedTab {
                case .feed:
                    VerticalFeedView()
                case .challenges:
                    ChallengesView()
                case .upload:
                    UploadView()
                case .ranks:
                    LeaderboardView()
                case .profile:
                    ProfileView(creator: appState.me, isMe: true)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea(edges: appState.selectedTab == .feed ? .all : [])

            GlassDock(selection: $appState.selectedTab)
                .padding(.horizontal, 18)
                .padding(.bottom, 10)
        }
        .ignoresSafeArea(.keyboard)
    }
}

struct GlassDock: View {
    @Binding var selection: RootTab

    private let items: [(RootTab, String, String)] = [
        (.feed, "Stage", "play.fill"),
        (.challenges, "Arena", "flame.fill"),
        (.upload, "Drop", "plus"),
        (.ranks, "Ladder", "trophy.fill"),
        (.profile, "You", "person.fill"),
    ]

    var body: some View {
        HStack(spacing: 4) {
            ForEach(items, id: \.0) { tab, title, icon in
                let on = selection == tab
                Button {
                    withAnimation(.spring(response: 0.38, dampingFraction: 0.82)) {
                        selection = tab
                    }
                } label: {
                    VStack(spacing: 4) {
                        ZStack {
                            if tab == .upload {
                                Circle()
                                    .fill(EVTheme.acid)
                                    .frame(width: 38, height: 38)
                                    .shadow(color: EVTheme.acid.opacity(0.45), radius: 12, y: 2)
                                Image(systemName: icon)
                                    .font(.system(size: 17, weight: .black))
                                    .foregroundStyle(EVTheme.ink)
                            } else {
                                Image(systemName: icon)
                                    .font(.system(size: 16, weight: .bold))
                                    .foregroundStyle(on ? EVTheme.acid : EVTheme.paper.opacity(0.75))
                                    .frame(height: 22)
                            }
                        }
                        Text(title)
                            .font(.system(size: 10, weight: .heavy, design: .rounded))
                            .foregroundStyle(on ? EVTheme.paper : EVTheme.mist)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 10)
                    .background {
                        if on && tab != .upload {
                            Capsule()
                                .fill(EVTheme.acid.opacity(0.14))
                                .padding(.horizontal, 4)
                                .overlay {
                                    Capsule()
                                        .strokeBorder(EVTheme.acid.opacity(0.25), lineWidth: 1)
                                        .padding(.horizontal, 4)
                                }
                        }
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background {
            LiquidGlassBackground(cornerRadius: 32, intensity: 1.05)
        }
    }
}
