import SwiftUI

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

extension Color {
    // MARK: - Black Elk Mountain Medicine 2025 Palette
    
    /// Primary brand tone used for headers and key actions (#2E5C40).
    static let forestGreen = Color(hex: "2E5C40")
    
    /// Accent tone for highlights and calls-to-action (#D4A574).
    static let warmEarth = Color(hex: "D4A574")
    
    /// Alert/danger tone meeting WCAG contrast (#A62F2F).
    static let deepCrimson = Color(hex: "A62F2F")
    
    /// Light neutral for app backgrounds (#F8F4EF).
    static let lightSand = Color(hex: "F8F4EF")
    
    /// Primary text color (#4A4A4A).
    static let darkCharcoal = Color(hex: "4A4A4A")
    
    /// Muted sage used for dividers/borders (#C4C7B2).
    static let sageAsh = Color(hex: "C4C7B2")
    
    // MARK: - Legacy Palette (kept for backward compatibility during rebrand)
    
    /// Deep Mountain Teal/Navy - Base background
    static let deepTeal = Color(hex: "0B3D4C")
    
    /// Darker variant for depth
    static let deepTealDark = Color(hex: "072832")
    
    /// Rescue Orange - Primary Action
    static let rescueOrange = Color(hex: "FF5722")
    
    /// Lighter Teal - Surface/Cards
    static let surfaceTeal = Color(hex: "1A4F60")
    
    /// Muted Teal - Secondary Elements
    static let mutedTeal = Color(hex: "4A7A8C")
    
    /// Off-white with subtle teal tint - Primary Text
    static let mistWhite = Color(hex: "F0F7FA")
    
    /// Light Gray with teal tint - Secondary Text
    static let mistGray = Color(hex: "B0C4CD")
}

