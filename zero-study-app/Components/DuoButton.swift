import SwiftUI

enum DuoButtonVariant {
    case green, blue, orange, red, gray
    
    var backgroundColor: Color {
        switch self {
        case .green: return .duoGreen
        case .blue: return .duoBlue
        case .orange: return .duoOrange
        case .red: return .duoRed
        case .gray: return .white // Handled specially for dark mode below
        }
    }
    
    var borderColor: Color {
        switch self {
        case .green: return .duoGreenDark
        case .blue: return .duoBlueDark
        case .orange: return .duoOrangeDark
        case .red: return .duoRedDark
        case .gray: return .duoGray
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .gray: return .duoGrayDark
        default: return .white
        }
    }
}

struct DuoButtonStyle: ButtonStyle {
    var variant: DuoButtonVariant
    var fullWidth: Bool = false
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        let isGray = variant == .gray
        
        let bg = isGray ? (colorScheme == .dark ? Color.cardDarkBg : Color.white) : variant.backgroundColor
        let border = isGray ? (colorScheme == .dark ? Color.cardBorderDark : Color.duoGray) : variant.borderColor
        let fg = isGray ? (colorScheme == .dark ? Color(hex: "52656d") : Color.duoGrayDark) : variant.foregroundColor
        
        return configuration.label
            .font(.system(size: 18, weight: .bold))
            .foregroundColor(fg)
            .padding(.vertical, 14)
            .padding(.horizontal, 24)
            .frame(maxWidth: fullWidth ? .infinity : nil)
            .background(bg)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(border, lineWidth: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(border, lineWidth: isPressed ? 0 : 4)
                    .padding(.top, isPressed ? 0 : 2)
                    .mask(VStack { Spacer(); Rectangle().frame(height: isPressed ? 0 : 4) })
            )
            .offset(y: isPressed ? 2 : 0)
            .animation(.spring(response: 0.2, dampingFraction: 0.6), value: isPressed)
    }
}

extension Button {
    func duoButtonStyle(variant: DuoButtonVariant = .green, fullWidth: Bool = false) -> some View {
        self.buttonStyle(DuoButtonStyle(variant: variant, fullWidth: fullWidth))
    }
}
