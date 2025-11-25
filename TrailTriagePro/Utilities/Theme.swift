import SwiftUI

/// Centralized Design System for TrailTriage
/// 2025 “Black Elk” refresh with earthy palette + approachable typography.
enum Theme {
    // MARK: - Colors
    
    static var primary: Color { .forestGreen }
    static var accent: Color { .warmEarth }
    static var alert: Color { .deepCrimson }
    
    static var background: Color { .lightSand }
    static var surface: Color { .white }
    static var surfaceMuted: Color { Color.white.opacity(0.9) }
    
    static var textPrimary: Color { .darkCharcoal }
    static var textSecondary: Color { Color.darkCharcoal.opacity(0.7) }
    static var divider: Color { .sageAsh.opacity(0.5) }
    
    // MARK: - Gradients
    
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color.lightSand, Color.white],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [.forestGreen, .warmEarth],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    static var headerGradient: LinearGradient {
        LinearGradient(
            colors: [.forestGreen.opacity(0.95), .forestGreen.opacity(0.7)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography helpers
    
    private static func baseText(_ text: String, style: Font.TextStyle, weight: Font.Weight = .regular, color: Color = Theme.textPrimary) -> some View {
        Text(text)
            .font(.system(style, design: .default, weight: weight))
            .foregroundStyle(color)
            .lineSpacing(4)
            .kerning(0.2)
            .multilineTextAlignment(.leading)
    }
    
    static func title(_ text: String) -> some View {
        baseText(text, style: .title2, weight: .bold)
    }
    
    static func headline(_ text: String) -> some View {
        baseText(text, style: .headline, weight: .semibold)
    }
    
    static func body(_ text: String) -> some View {
        baseText(text, style: .body)
    }
    
    static func subheadline(_ text: String) -> some View {
        baseText(text, style: .subheadline, color: textSecondary)
    }
    
    static func caption(_ text: String, weight: Font.Weight = .medium) -> some View {
        baseText(text.uppercased(), style: .caption, weight: weight, color: textSecondary)
    }
}

// MARK: - View Modifiers

struct TrailBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            Theme.backgroundGradient.ignoresSafeArea()
            content
        }
    }
}

struct TrailCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 6)
    }
}

struct TrailButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline, design: .default, weight: .bold))
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .shadow(color: Theme.primary.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

extension View {
    /// Applies the TrailTriage background styling.
    func trailBackground() -> some View {
        modifier(TrailBackgroundModifier())
    }
    
    /// Styles the view as a standard card.
    func trailCard() -> some View {
        modifier(TrailCardModifier())
    }
    
    /// Styles the view as a branded primary button.
    func trailButton() -> some View {
        modifier(TrailButtonModifier())
    }
    
    /// Applies the brand font style with optional weight.
    func brandFont(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> some View {
        self.font(.system(style, design: .default, weight: weight))
            .lineSpacing(4)
            .kerning(0.2)
            .multilineTextAlignment(.leading)
    }
}
