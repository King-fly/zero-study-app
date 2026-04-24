import SwiftUI

extension Color {
    static let duoGreen = Color(hex: "58cc02")
    static let duoGreenDark = Color(hex: "46a302")
    static let duoBlue = Color(hex: "1cb0f6")
    static let duoBlueDark = Color(hex: "1899d6")
    static let duoOrange = Color(hex: "ff9600")
    static let duoOrangeDark = Color(hex: "e68a00")
    static let duoRed = Color(hex: "ff4b4b")
    static let duoRedDark = Color(hex: "e54444")
    static let duoGray = Color(hex: "e5e5e5")
    static let duoGrayDark = Color(hex: "afafaf")
    
    // Background colors
    static let lightBg = Color.white
    static let darkBg = Color(hex: "131f24")
    
    static let cardLightBg = Color.white
    static let cardDarkBg = Color(hex: "1f2e35")
    
    static let cardBorderDark = Color(hex: "37464f")
}

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

struct CardStyle: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    
    func body(content: Content) -> some View {
        content
            .background(colorScheme == .dark ? Color.cardDarkBg : Color.cardLightBg)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .dark ? Color.cardBorderDark : Color.duoGray, lineWidth: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(colorScheme == .dark ? Color.cardBorderDark : Color.duoGray, lineWidth: 4)
                    .padding(.top, 2)
                    .mask(VStack { Spacer(); Rectangle().frame(height: 4) })
            )
    }
}

extension View {
    func duoCardStyle() -> some View {
        self.modifier(CardStyle())
    }
}
