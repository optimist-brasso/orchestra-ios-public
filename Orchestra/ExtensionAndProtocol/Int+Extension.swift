//
//  Int+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 20/04/2022.
//

import Foundation

extension Int {
    
    var time: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        let string = formatter.string(from: TimeInterval(self))!
        if string.contains(":") {
            return string
        }
        return "00:\(string)"
    }
    
    var comma: String {
        let numberFormatter = NumberFormatter()
        numberFormatter.locale = Locale(identifier: "en")
        numberFormatter.groupingSeparator = ","
        numberFormatter.groupingSize = 3
        numberFormatter.numberStyle = .decimal
        return numberFormatter.string(from: self as NSNumber)!
    }

}
