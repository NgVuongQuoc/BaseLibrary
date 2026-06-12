//
//  Date+Extension.swift
//  calendar
//
//  Created by Mobifone IT Ptpm on 19/11/25.
//

import Foundation

public extension Date {
    /// Tạo Date từ ngày, tháng, năm
    static func from(day: Int, month: Int, year: Int) -> Date {
        var components = DateComponents()
        components.day = day
        components.month = month
        components.year = year
        return Calendar.current.date(from: components) ?? Date()
    }
    
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    var month: Int {
        return Calendar.current.component(.month, from: self)
    }
    
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
}
