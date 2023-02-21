//
//  DateFormatter+Extension.swift
//  Orchestra
//
//  Created by Mukesh Shakya on 18/04/2022.
//

import Foundation
import UIKit

extension TimeZone {
    static let utc = TimeZone(identifier: "UTC")!
}

extension DateFormatter {
    
    static func toDate(dateString: String, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", timeZone: TimeZone = .current ) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: NSLocale.current.identifier)
        formatter.timeZone = timeZone
        return formatter.date(from: dateString)
    }
    
    static func toString(date: Date, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'" , locale: String = "",  timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        formatter.locale = locale.isEmpty ? Locale(identifier: NSLocale.current.identifier) : Locale(identifier: locale)
        return formatter.string(from: date)
    }
    
    static func toStringJPLocale(date: Date, format: String = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'") -> String {
        toString(date: date, format:format, locale: "ja_JP")
    }
}
