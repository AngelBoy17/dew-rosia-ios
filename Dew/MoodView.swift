import SwiftUI
import UIKit

private struct MoodOption: Identifiable {
    let id = UUID()
    let emoji: String
    let title: String
    let tint: Color
}

struct MoodView: View {
    @EnvironmentObject private var moodStore: MoodStore

    private let options: [MoodOption] = [
        .init(emoji: "🌿", title: "Спокойно", tint: DewPalette.mint),
        .init(emoji: "☀️", title: "Тепло", tint: DewPalette.peach),
        .init(emoji: "⚡️", title: "Энергия", tint: DewPalette.teal),
        .init(emoji: "🌊", title: "Тишина", tint: DewPalette.lilac),
        .init(emoji: "🎯", title: "Фокус", tint: Color.white)
    ]

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                Text("Как ты сегодня")
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.7))
                    .padding(.top, 22)

                Text("Отметь настроение — оно останется на главной до завтра.")
                    .font(.system(size: 22, weight: .medium, design: .rounded))
                    .foregroundStyle(DewPalette.foam)

                if let today = moodStore.today {
                    LiquidGlass(cornerRadius: 28, tint: DewPalette.mint) {
                        HStack(spacing: 14) {
                            Text(today.emoji)
                                .font(.system(size: 36))
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Сегодня")
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .foregroundStyle(Color.white.opacity(0.6))
                                Text(today.title)
                                    .font(.system(size: 20, weight: .semibold, design: .rounded))
                                    .foregroundStyle(DewPalette.foam)
                            }
                            Spacer()
                        }
                        .padding(20)
                    }
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(options) { option in
                        Button {
                            UIImpactFeedbackGenerator(style: .soft).impactOccurred()
                            moodStore.set(emoji: option.emoji, title: option.title)
                        } label: {
                            LiquidGlass(cornerRadius: 26, tint: option.tint) {
                                VStack(spacing: 10) {
                                    Text(option.emoji)
                                        .font(.system(size: 32))
                                    Text(option.title)
                                        .font(.system(size: 16, weight: .semibold, design: .rounded))
                                        .foregroundStyle(DewPalette.foam)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.vertical, 22)
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 24)
        }
    }
}
