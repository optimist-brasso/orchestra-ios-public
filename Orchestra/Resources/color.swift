//
//  color.swift
//  Orchestra
//
//  Created by manjil on 30/03/2022.
//

import UIKit

extension UIColor {
    
    /// Helper method to verify and return color if assets has it
    /// - Parameter colorName: the name of color from asset
    /// - Returns: the color from name
    private static func named(_ colorName: String) -> UIColor {
        guard let color = UIColor(named: colorName) else {
            fatalError("The color associted with name \(colorName) counld not be found. Please check that you spelled it correctly.")
        }
        return color
    }
    /// #6A6969
    static var border: UIColor { UIColor.named("border") }
    /// #262626
    static var buttonBackground: UIColor {  UIColor.named("buttonBackground") }
    /// #333333
    static var background: UIColor { UIColor.named("background") }
    /// #00DEA2
    static var navTitleColor: UIColor { UIColor.named("navTitleColor") }
    ///#0D6483
    static var blueButtonBackground: UIColor { UIColor.named("blueButtonBackground") }
    /// #343434
    static var blackBackground: UIColor { UIColor.named("blackBackground") }
    
    static var placeholder = UIColor(hexString: "CACACA")
   
    static var textBackground = UIColor(hexString: "EDEDED")
    
    static var line = UIColor(hexString: "06C755")
    
    static var facebook = UIColor(hexString: "1B77F4")
    
    static var twitter = UIColor(hexString: "#1DA1F2")
    
    static var appGreen = UIColor(hexString: "#00DEA2")
                                    
}


