//
//  Font.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import UIKit

enum FontSize: CGFloat {
    
    case size8 = 8
    case size14 = 14.0
    case size9 = 9
    case size10 = 10
    case size10_8 = 10.8
    case size11 = 11.0
    case size12 = 12
    case size12_6 = 12.6
    case size13 = 13
    case size14_4 = 14.4
    case size15 = 15.0
    case size16 = 16.0
    case size17 = 17.0
    case size17_6 = 17.6
    case size18 = 18.0
    case size19 = 19.0
    case size20 = 20.0
    case size22 = 22.0
    case size24 = 24.0
    case size25 = 25.0
    case size28 = 28.0
    case size30 = 30.0
    case size32 = 32.0
    case size34 = 34.0
    case size35 = 35.0
    case size36 = 36.0
    case size40 = 40.0
    case size42 = 42
    case size48 = 48
    case size60 = 60
    case size75 = 75.0
    
}

enum AppFontWeight {
    
    case regular
    case bold
    case semiBold
    case medium
    case light
    case extraBold
    case book
    case thin
    
}
//YuGothic-Bold
enum FontType {
    
    case system(UIFont.Weight)
    case notoSansJP(AppFontWeight)
    
    var name: String {
        switch self {
        case .system(_):
            fatalError("No font available in the system")

        case .notoSansJP(let weight):
            switch weight {
            case .regular:
                return "NotoSansJP-Regular"
            case .medium:
                return "NotoSansJP-Medium"
            case .bold:
                return "NotoSansJP-Bold"
            case .light:
                return "NotoSansJP-Light"
            case .thin:
                return "NotoSansJP-Thin"
            default:
                fatalError("No font available in the system \(self)")
            }
        }
    }
    
}

extension UIFont {
    
    static var boldItalicFont: UIFont {
        return UIFont(name: "HelveticaNeue-BoldItalic", size: 14) ?? .italicSystemFont(ofSize: 14)
    }
    
    static func notoSansJPBold(size: FontSize) -> UIFont {
        appFont(type: .notoSansJP(.bold), size: size)
    }
    
    static func notoSansJPMedium(size: FontSize) -> UIFont {
        appFont(type: .notoSansJP(.medium), size: size)
    }
    
    static func notoSansJPRegular(size: FontSize) -> UIFont {
        appFont(type: .notoSansJP(.regular), size: size)
    }
    static func notoSansJPLight(size: FontSize) -> UIFont {
        appFont(type: .notoSansJP(.light), size: size)
    }
    
    static func appFont(type: FontType, size: FontSize = .size16) -> UIFont {
        if case .system = type {
            return UIFont().customSystemFont(type: type, size: size)
        }
        guard let font = UIFont(name: type.name, size: size.rawValue) else {
            fatalError("No \(type.name) font available in the system")
        }
        return font
    }
    
    private func customSystemFont(type: FontType, size: FontSize ) -> UIFont {
        switch type {
        case .system(let weight):
            return  .systemFont(ofSize: size.rawValue, weight: weight)
        default:
            fatalError("No font available in the system")
        }
        
    }
    
    /// Helper method to print all the available fonts supported by system
    static func printSupportedFonts() {
        let families = UIFont.familyNames.sorted()
        debugPrint("**************** START PRINTING SUPPORTED FONTS ****************")
        for family in families {
            let fonts = UIFont.fontNames(forFamilyName: family)
            debugPrint()
            debugPrint("-- \(family) --")
            fonts.forEach {
                debugPrint($0)
            }
            debugPrint()
        }
        debugPrint("**************** END PRINTING SUPPORTED FONTS ****************")
    }
    
}
