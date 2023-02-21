//
//  Double+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 12/05/2022.
//

import Foundation

extension Double {
    
    var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == .zero ? String(format: "%.0f", self) : String(self)
    }
    
    var currencyMode: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en")
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.secondaryGroupingSize = 3
        numberFormatter.usesGroupingSeparator = true
        numberFormatter.decimalSeparator = "."
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = 1
        return numberFormatter.string(from: self as NSNumber)!
    }
    
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
        let hours = (time / 3600)
        if hours < 1 {
            return String(format: "%0.2d:%0.2d",minutes,seconds)
        } else {
            return String(format: "%0.2d:%0.2d:%0.2d",hours,minutes,seconds)
        }
    }

}
