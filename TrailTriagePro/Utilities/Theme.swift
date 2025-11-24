import SwiftUI

/// Centralized Design System for TrailTriage
/// Implements the "Mountain Medicine" aesthetic with Deep Teal backgrounds and Rescue Orange accents.
enum Theme {
    // MARK: - Colors
    
    /// The core tint color for the app (Rescue Orange)
    static var tint: Color { Color.rescueOrange }
    
    /// The main background color (Deep Mountain Teal)
    static var background: Color { Color.deepTeal }
    
    /// A darker background for creating depth (e.g., behind cards)
    static var backgroundDark: Color { Color.deepTealDark }
    
    /// Surface color for cards and sheets
    static var surface: Color { Color.surfaceTeal }
    
    /// Primary text color (Mist White)
    static var textPrimary: Color { Color.mistWhite }
    
    /// Secondary text color (Mist Gray)
    static var textSecondary: Color { Color.mistGray }
    
    /// Accent color for secondary elements
    static var accentSecondary: Color { Color.mutedTeal }
    
    // MARK: - Gradients
    
    /// A subtle atmospheric gradient for backgrounds
    static var backgroundGradient: LinearGradient {
        LinearGradient(
            colors: [Color.deepTeal, Color.deepTealDark],
            startPoint: .top,
            endPoint: .bottom
        )
    }
    
    /// A high-impact gradient for primary buttons/headers
    static var primaryGradient: LinearGradient {
        LinearGradient(
            colors: [Color.rescueOrange, Color.rescueOrange.opacity(0.8)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
    
    // MARK: - Typography
    
    static func title(_ text: String) -> Text {
        Text(text)
            .font(.system(.title, design: .rounded))
            .fontWeight(.bold)
            .foregroundStyle(textPrimary)
    }
    
    static func headline(_ text: String) -> Text {
        Text(text)
            .font(.system(.headline, design: .rounded))
            .fontWeight(.semibold)
            .foregroundStyle(textPrimary)
    }
    
    static func body(_ text: String) -> Text {
        Text(text)
            .font(.system(.body, design: .rounded))
            .foregroundStyle(textPrimary)
    }
    
    static func subheadline(_ text: String) -> Text {
        Text(text)
            .font(.system(.subheadline, design: .rounded))
            .foregroundStyle(textSecondary)
    }
    
    static func caption(_ text: String) -> Text {
        Text(text)
            .font(.system(.caption, design: .rounded))
            .foregroundStyle(textSecondary)
    }
}

// MARK: - View Modifiers

struct MountainBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            Theme.backgroundGradient.ignoresSafeArea()
            content
        }
    }
}

struct MountainCardModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: 16))
            .shadow(color: Color.black.opacity(0.2), radius: 8, x: 0, y: 4)
    }
}

struct MountainButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.headline, design: .rounded))
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding()
            .frame(maxWidth: .infinity)
            .background(Theme.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .shadow(color: Theme.tint.opacity(0.3), radius: 8, x: 0, y: 4)
    }
}

extension View {
    /// Applies the standard Mountain Medicine background
    func mountainBackground() -> some View {
        modifier(MountainBackgroundModifier())
    }
    
    /// Styles the view as a standard card
    func mountainCard() -> some View {
        modifier(MountainCardModifier())
    }
    
    /// Styles the view as a primary action button
    func mountainButton() -> some View {
        modifier(MountainButtonModifier())
    }
    
    /// Applies the brand font style
    func brandFont(_ style: Font.TextStyle, weight: Font.Weight = .regular) -> some View {
        self.font(.system(style, design: .rounded).weight(weight))
    }
}

