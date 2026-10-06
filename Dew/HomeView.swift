import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var moodStore: MoodStore
    @State private var now = Date()

    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 18) {
                Text(greeting)
                    .font(.system(size: 15, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.72))
                    .padding(.top, 18)

                Text(timeString)
                    .font(.system(size: 64, weight: .light, design: .rounded))
                    .foregroundStyle(DewPalette.foam)
                    .minimumScaleFactor(0.6)
                    .lineLimit(1)

                Text(dateString)
                    .font(.system(size: 17, weight: .regular, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.7))

                LiquidGlass(cornerRadius: 32) {
                    VStack(alignment: .leading, spacing: 10) {
                        Label("Капля дня", systemImage: "sparkles")
                            .font(.system(size: 13, weight: .semibold, design: .rounded))
                            .foregroundStyle(DewPalette.mint)
                        Text(dailyDrop)
                            .font(.system(size: 20, weight: .medium, design: .rounded))
                            .foregroundStyle(DewPalette.foam)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(22)
                }

                HStack(spacing: 12) {
                    miniCard(
                        title: "Настроение",
                        value: moodStore.today.map { "\($0.emoji) \($0.title)" } ?? "ещё не отмечено",
                        symbol: "heart.fill"
                    )
                    miniCard(
                        title: "Дыхание",
                        value: "4 · 4 · 4",
                        symbol: "wind"
                    )
                }
            }
            .padding(.horizontal, 22)
            .padding(.bottom, 24)
        }
        .onReceive(timer) { now = $0 }
    }

    private var greeting: String {
        let hour = Calendar.current.component(.hour, from: now)
        switch hour {
        case 5..<12: return "Доброе утро"
        case 12..<18: return "Добрый день"
        case 18..<23: return "Добрый вечер"
        default: return "Доброй ночи"
        }
    }

    private var timeString: String {
        now.formatted(date: .omitted, time: .shortened)
    }

    private var dateString: String {
        now.formatted(.dateTime.weekday(.wide).day().month(.wide))
    }

    private var dailyDrop: String {
        let phrases = [
            "Тише вода — яснее отражение.",
            "Одна спокойная минута меняет весь день.",
            "Дыши: всё лишнее стекает вниз.",
            "Свет мягче, если не торопиться.",
            "Капля за каплей собирается ясность.",
            "Стекло держит свет, ты — внимание.",
            "Можно ничего не решать прямо сейчас."
        ]
        let day = Calendar.current.ordinality(of: .day, in: .year, for: now) ?? 1
        return phrases[day % phrases.count]
    }

    private func miniCard(title: String, value: String, symbol: String) -> some View {
        LiquidGlass(cornerRadius: 26) {
            VStack(alignment: .leading, spacing: 8) {
                Image(systemName: symbol)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(DewPalette.teal)
                Text(title)
                    .font(.system(size: 12, weight: .medium, design: .rounded))
                    .foregroundStyle(Color.white.opacity(0.6))
                Text(value)
                    .font(.system(size: 15, weight: .semibold, design: .rounded))
                    .foregroundStyle(DewPalette.foam)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(18)
        }
    }
}
