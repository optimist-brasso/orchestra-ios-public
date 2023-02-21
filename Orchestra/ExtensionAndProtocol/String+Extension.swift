//
//  String.swift
//  Orchestra
//
//  Created by manjil on 31/03/2022.
//

import Foundation
import UIKit

extension String {
    
    func attributeText(attribute: [NSAttributedString.Key: Any]) -> NSAttributedString {
        return NSAttributedString(string: self, attributes: attribute)
    }
    var trim: String {
        self.trimmingCharacters(in: .whitespaces)
    }
    
    var placeholder: NSAttributedString {
        self.attributeText(attribute: [.font: UIFont.notoSansJPRegular(size: .size14), .foregroundColor: UIColor.placeholder])
    }
    
    func toDate(format: SupportFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
    
    func height(with width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        return boundingBox.height
    }
    
    func convertDateFormat(from: SupportFormat, to: SupportFormat) -> String {
        let toDate = self.toDate(format: from)
        return toDate?.toString(format: to) ?? ""
    }
    
    var formattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "MM/yyyy"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    var wordsFormattedDate: String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/yyyy"
        if let date = dateFormatter.date(from: self) {
            dateFormatter.dateFormat = "yyyy/M"
            return dateFormatter.string(from: date)
        }
        return nil
    }
    
    var fileName: String? {
        let urlArray = components(separatedBy: "?Expires=")
        return urlArray.first?.components(separatedBy: "/").last
    }
    
    var currentLocalPath: String? {
        guard let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
              let fileName = fileName else { return nil }
        return documentsURL.appendingPathComponent(fileName).absoluteString
    }
    
    func timeStringToInt() -> Int {
        let components = self.split(separator: ":")
        if components.count == 3 {
            let hours = Int(components[0])!
            let minutes = Int(components[1])!
            let sec = Int(components[2])!
            return (hours * 60 * 60) + (minutes * 60) + (sec)
        }else{
            let minutes = Int(components[0])!
            let sec = Int(components[1])!
            return (minutes * 60) + (sec)
        }
       
    }
    
}
