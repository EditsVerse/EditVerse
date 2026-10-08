import SwiftUI

enum EVTheme {
    static let void = Color(hex: 0x05060A)
    static let ink = Color(hex: 0x0B0D10)
    static let panel = Color(hex: 0x12161E)
    static let line = Color(hex: 0x2C3445)
    static let mist = Color(hex: 0xA7B0C0)
    static let paper = Color(hex: 0xF3F0E7)
    static let acid = Color(hex: 0xC8F542)
    static let heat = Color(hex: 0xFF6A3D)
    static let ice = Color(hex: 0x7DE0FF)

    static let stageTitle = Font.system(size: 42, weight: .black, design: .rounded)
    static let hud = Font.system(size: 12, weight: .bold, design: .monospaced)
}

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
