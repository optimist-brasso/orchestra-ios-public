//
//  Date+Extension.swift
//  Orchestra
//
//  Created by manjil on 08/04/2022.
//

import Foundation
enum SupportFormat: String {
    case dashYYYYMMDD = "yyyy-MM-dd"
    case dashYYYY = "YYYY"
    case slashDDMMYYYY = "dd/MM/yyyy"
    case slashYYYYMMDD = "yyyy/MM/dd"
    
}

extension Date {
    
    func toString(format: SupportFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale  = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    func toStringJp(format: SupportFormat) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "JST")
        dateFormatter.locale  = Locale(identifier: "en_US")
        return dateFormatter.string(from: self)
    }
    
    public  func addYear(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .year, value: n, to: self)!
    }
    
    public  func addMonth(n: Int) -> Date {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: n, to: self)!
    }
    
    public  func stringDate() -> String {
        let calendar  = Calendar.current
        let dateFormatter = DateFormatter()
        
        dateFormatter.timeZone = calendar.timeZone
        dateFormatter.locale = calendar.locale
        // Use YYYY to show year only.
        // Use MMMM to show month only.
        dateFormatter.setLocalizedDateFormatFromTemplate("MMMM YYYY")
        
        let dateString = dateFormatter.string(from: self)
        return dateString
    }
    
    
    func test() -> [String] {
        var dates: [String] = []
        var date = Date().addYear(n: -100)
        let endDate = Date()
        repeat {
            date = date.addYear(n: 1)
            let dataString = date.toString(format: .dashYYYY)
            dates.append(dataString)
        } while date <= endDate
        
        return dates
    }
    
    
}
