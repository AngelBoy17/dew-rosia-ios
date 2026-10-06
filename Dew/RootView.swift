import SwiftUI

enum DewTab: Hashable {
    case home, breathe, mood
}

struct RootView: View {
    @State private var tab: DewTab = .home

    var body: some View {
        ZStack {
            LiquidBackground()

            VStack(spacing: 0) {
                Group {
                    switch tab {
                    case .home:
                        HomeView()
                    case .breathe:
                        BreatheView()
                    case .mood:
                        MoodView()
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                LiquidGlass(cornerRadius: 30) {
                    HStack(spacing: 4) {
                        GlassIconButton(systemName: "drop.fill", selected: tab == .home, title: "Роса") {
                            tab = .home
                        }
                        GlassIconButton(systemName: "wind", selected: tab == .breathe, title: "Дыхание") {
                            tab = .breathe
                        }
                        GlassIconButton(systemName: "heart.fill", selected: tab == .mood, title: "Настрой") {
                            tab = .mood
                        }
                    }
                    .padding(8)
                }
                .padding(.horizontal, 22)
                .padding(.bottom, 12)
            }
        }
    }
}
