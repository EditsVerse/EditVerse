import SwiftUI

struct RootTabView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        @Bindable var appState = appState

        TabView(selection: $appState.selectedTab) {
            FeedView()
                .tabItem { Label("Feed", systemImage: "play.rectangle.on.rectangle") }
                .tag(RootTab.feed)

            ChallengesView()
                .tabItem { Label("Challenges", systemImage: "flame") }
                .tag(RootTab.challenges)

            UploadView()
                .tabItem { Label("Upload", systemImage: "plus.rectangle.on.rectangle") }
                .tag(RootTab.upload)

            LeaderboardView()
                .tabItem { Label("Ranks", systemImage: "trophy") }
                .tag(RootTab.ranks)

            ProfileView(creator: appState.me, isMe: true)
                .tabItem { Label("Profile", systemImage: "person.crop.circle") }
                .tag(RootTab.profile)
        }
        .tint(EVTheme.acid)
        .toolbarBackground(EVTheme.ink, for: .tabBar)
        .toolbarBackground(.visible, for: .tabBar)
    }
}
