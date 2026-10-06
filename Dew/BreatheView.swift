import SwiftUI

private enum BreathPhase: CaseIterable {
    case inhale, hold, exhale

    var title: String {
        switch self {
        case .inhale: return "Вдох"
        case .hold: return "Пауза"
        case .exhale: return "Выдох"
        }
    }

    var seconds: Int {
        4
    }

    var scale: CGFloat {
        switch self {
        case .inhale: return 1.18
        case .hold: return 1.18
        case .exhale: return 0.82
        }
    }
}

struct BreatheView: View {
    @State private var running = false
    @State private var phase: BreathPhase = .inhale
    @State private var remaining = 4
    @State private var pulse = false

    private let ticker = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        VStack(spacing: 28) {
            Text("Дыхание")
                .font(.system(size: 15, weight: .medium, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.7))
                .padding(.top, 22)

            Spacer()

            ZStack {
                Circle()
                    .fill(
                        RadialGradient(
                            colors: [
                                DewPalette.teal.opacity(0.45),
                                DewPalette.lilac.opacity(0.12),
                                Color.clear
                            ],
                            center: .center,
                            startRadius: 10,
                            endRadius: 170
                        )
                    )
                    .frame(width: 300, height: 300)
                    .scaleEffect(pulse ? 1.08 : 0.92)
                    .blur(radius: 8)

                LiquidGlass(cornerRadius: 140) {
                    VStack(spacing: 8) {
                        Text(running ? phase.title : "Готово")
                            .font(.system(size: 28, weight: .medium, design: .rounded))
                            .foregroundStyle(DewPalette.foam)
                        Text(running ? "\(remaining)" : "4 · 4 · 4")
                            .font(.system(size: 44, weight: .light, design: .rounded))
                            .foregroundStyle(DewPalette.mint)
                            .monospacedDigit()
                    }
                    .frame(width: 220, height: 220)
                }
                .scaleEffect(running ? phase.scale : 1)
            }
            .animation(.easeInOut(duration: 4), value: phase)
            .animation(.easeInOut(duration: 2.4).repeatForever(autoreverses: true), value: pulse)

            Text("Мягкий цикл: вдох, пауза, выдох — по 4 секунды.")
                .font(.system(size: 14, weight: .regular, design: .rounded))
                .foregroundStyle(Color.white.opacity(0.65))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button {
                toggle()
            } label: {
                Text(running ? "Остановить" : "Начать")
                    .font(.system(size: 17, weight: .semibold, design: .rounded))
                    .foregroundStyle(DewPalette.deep)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        Capsule(style: .continuous)
                            .fill(
                                LinearGradient(
                                    colors: [DewPalette.mint, DewPalette.teal],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                    )
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 36)

            Spacer()
        }
        .onAppear { pulse = true }
        .onReceive(ticker) { _ in
            guard running else { return }
            remaining -= 1
            if remaining <= 0 {
                advance()
            }
        }
    }

    private func toggle() {
        running.toggle()
        if running {
            phase = .inhale
            remaining = phase.seconds
        }
    }

    private func advance() {
        switch phase {
        case .inhale: phase = .hold
        case .hold: phase = .exhale
        case .exhale: phase = .inhale
        }
        remaining = phase.seconds
    }
}
