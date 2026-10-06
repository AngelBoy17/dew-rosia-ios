import Foundation
import Combine

struct DailyMood: Codable, Equatable {
    var dayKey: String
    var emoji: String
    var title: String
}

final class MoodStore: ObservableObject {
    @Published var today: DailyMood?

    private let key = "dew.today.mood"
    private static let formatter: DateFormatter = {
        let f = DateFormatter()
        f.calendar = Calendar(identifier: .gregorian)
        f.dateFormat = "yyyy-MM-dd"
        return f
    }()

    init() {
        load()
    }

    func set(emoji: String, title: String) {
        let mood = DailyMood(dayKey: Self.todayKey(), emoji: emoji, title: title)
        today = mood
        if let data = try? JSONEncoder().encode(mood) {
            UserDefaults.standard.set(data, forKey: key)
        }
    }

    private func load() {
        guard
            let data = UserDefaults.standard.data(forKey: key),
            let mood = try? JSONDecoder().decode(DailyMood.self, from: data),
            mood.dayKey == Self.todayKey()
        else {
            today = nil
            return
        }
        today = mood
    }

    static func todayKey(_ date: Date = Date()) -> String {
        formatter.string(from: date)
    }
}
