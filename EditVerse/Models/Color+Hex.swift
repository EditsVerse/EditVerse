import SwiftUI

extension Color {
    init(hex: UInt, opacity: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xFF) / 255,
            green: Double((hex >> 8) & 0xFF) / 255,
            blue: Double(hex & 0xFF) / 255,
            opacity: opacity
        )
    }
}

enum EVTheme {
    static let ink = Color(hex: 0x0B0D10)
    static let panel = Color(hex: 0x14181F)
    static let line = Color(hex: 0x2A3140)
    static let mist = Color(hex: 0xA7B0C0)
    static let paper = Color(hex: 0xF4F1E8)
    static let acid = Color(hex: 0xC8F542)
    static let heat = Color(hex: 0xFF6A3D)
}
