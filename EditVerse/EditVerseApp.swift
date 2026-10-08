import SwiftUI

@main
struct EditVerseApp: App {
    @State private var appState = AppState()

    var body: some Scene {
        WindowGroup {
            AppShell()
                .environment(appState)
                .preferredColorScheme(.dark)
        }
    }
}
