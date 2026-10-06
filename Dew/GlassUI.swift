import SwiftUI

enum DewPalette {
    static let deep = Color(red: 0.04, green: 0.09, blue: 0.16)
    static let teal = Color(red: 0.35, green: 0.86, blue: 0.88)
    static let mint = Color(red: 0.62, green: 0.96, blue: 0.82)
    static let lilac = Color(red: 0.67, green: 0.62, blue: 1.00)
    static let peach = Color(red: 1.00, green: 0.72, blue: 0.64)
    static let foam = Color.white.opacity(0.88)
}

struct LiquidBackground: View {
    var body: some View {
        TimelineView(.animation) { timeline in
            let t = timeline.date.timeIntervalSinceReferenceDate

            ZStack {
                DewPalette.deep

                blob(DewPalette.teal, size: 340, x: 0.18 + 0.08 * cos(t * 0.35), y: 0.22 + 0.06 * sin(t * 0.28))
                blob(DewPalette.lilac, size: 300, x: 0.82 + 0.07 * sin(t * 0.31), y: 0.28 + 0.08 * cos(t * 0.24))
                blob(DewPalette.peach, size: 280, x: 0.28 + 0.09 * sin(t * 0.22), y: 0.78 + 0.05 * cos(t * 0.33))
                blob(DewPalette.mint, size: 260, x: 0.78 + 0.06 * cos(t * 0.27), y: 0.72 + 0.07 * sin(t * 0.19))
                blob(.white, size: 160, x: 0.50 + 0.04 * sin(t * 0.4), y: 0.48 + 0.04 * cos(t * 0.37))
                    .opacity(0.22)
            }
            .ignoresSafeArea()
            .blur(radius: 42)
            .overlay {
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.08),
                        Color.clear,
                        Color.black.opacity(0.28)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
            }
        }
    }

    private func blob(_ color: Color, size: CGFloat, x: Double, y: Double) -> some View {
        GeometryReader { geo in
            Circle()
                .fill(color.opacity(0.55))
                .frame(width: size, height: size)
                .position(x: geo.size.width * x, y: geo.size.height * y)
        }
    }
}

struct LiquidGlass<Content: View>: View {
    var cornerRadius: CGFloat = 28
    var tint: Color = .white
    @ViewBuilder var content: Content

    var body: some View {
        content
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(.ultraThinMaterial)

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    tint.opacity(0.22),
                                    Color.white.opacity(0.04),
                                    DewPalette.teal.opacity(0.10)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(
                            LinearGradient(
                                colors: [
                                    Color.white.opacity(0.72),
                                    Color.white.opacity(0.14),
                                    DewPalette.teal.opacity(0.40)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 1.15
                        )

                    RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
                        .strokeBorder(Color.white.opacity(0.18), lineWidth: 0.6)
                        .blur(radius: 0.4)
                        .padding(1)
                }
            }
            .shadow(color: Color.black.opacity(0.22), radius: 22, y: 10)
    }
}

struct GlassIconButton: View {
    let systemName: String
    let selected: Bool
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 6) {
                Image(systemName: systemName)
                    .font(.system(size: 18, weight: .semibold))
                Text(title)
                    .font(.system(size: 11, weight: .medium))
            }
            .foregroundStyle(selected ? DewPalette.foam : Color.white.opacity(0.55))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .background {
                if selected {
                    Capsule(style: .continuous)
                        .fill(Color.white.opacity(0.16))
                        .overlay(
                            Capsule(style: .continuous)
                                .strokeBorder(Color.white.opacity(0.35), lineWidth: 1)
                        )
                }
            }
        }
        .buttonStyle(.plain)
    }
}
