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
    // MARK: - Mountain Medicine Palette
    
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

