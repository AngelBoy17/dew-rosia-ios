import SwiftUI

@main
struct DewApp: App {
    @StateObject private var moodStore = MoodStore()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(moodStore)
                .preferredColorScheme(.dark)
        }
    }
}
