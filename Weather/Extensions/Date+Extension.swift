//
//  Date+Extension.swift
//  Seravi
//
//  Created by Aleksey Trotsenko on 8/15/18.
//  Copyright © 2018 Aleksey Trotsenko. All rights reserved.
//

import Foundation

//MARK: - To string
extension Date {

    enum FormatType: String {
        case dayTime = "E, d LLLL"
        case hourTime = "HH"
        case dayName = "E"
    }

    func string(_ format: FormatType, timeZone: TimeZone = TimeZone.current) -> String {
        return dateFormatter(format.rawValue, timeZone: timeZone)
    }
    
    func dateFormatter(_ format: String, timeZone: TimeZone) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = timeZone

        return dateFormatter.string(from: self)
    }
}

extension String {
    
    func date(_ format: Date.FormatType, timeZone: TimeZone = TimeZone.current) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = timeZone
        return dateFormatter.date(from: self)
    }
}

extension Date {
    var startOfDay: Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay)!
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: startOfDay)
        return Calendar.current.date(from: components)!
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth)!
    }
}
