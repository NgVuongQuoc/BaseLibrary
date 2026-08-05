//
//  Extensions+DateFormatter.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation

public extension Date {
    public func zeroSeconds() -> Date {
        let calendar = Calendar.current
        let dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: self)
        return calendar.date(from: dateComponents)!
    }
    
    public func convertToString() -> String{
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd"
        let dateString = format.string(from: self)
        return dateString
    }
    public func getWeekend() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EE"
        return dateFormatter.string(from: self)
    }
    
    public func getDaysInMonth() -> Int?{
        var calendar = Calendar.current
        calendar.locale = Locale(identifier: "en_US_POSIX")
        let dateComponents = DateComponents(year: calendar.component(.year, from: self), month: calendar.component(.month, from: self))
        let date = calendar.date(from: dateComponents)!
        
        let range = calendar.range(of: .day, in: .month, for: date)
        let numDays = range?.count
        
        return numDays
    }
    
    public func getDayOfWeek() -> Int? {
        let todayDate = self
        let myCalendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        myCalendar.locale = Locale(identifier: "en_US_POSIX")
        let myComponents = myCalendar.components(.weekday, from: todayDate)
        return myComponents.weekday
    }
    
    public func getDay() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd LLLL YYYY"
        return dateFormatter.string(from: self)
    }
    
    public func getDayE() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMM"
        return dateFormatter.string(from: self)
    }
    
    public func getMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "LLLL", options: 0, locale: Locale(identifier: "en_US_POSIX"))
        return dateFormatter.string(from: self)
    }
    
    public func getNumberMonth() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "MM", options: 0, locale: Locale(identifier: "en_US_POSIX"))
        return dateFormatter.string(from: self)
    }
    
    public func getMonthAndYear() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar.current
        dateFormatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "LLLL YYYY", options: 0, locale: Locale(identifier: "en_US_POSIX"))
        return dateFormatter.string(from: self)
    }
    
    public func getTimeWithTimezone() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "HH:mm a"
        return dateFormatter.string(from: self)
    }
    
    public func getHour() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "HH"
        return dateFormatter.string(from: self)
    }
    
    public func getMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "mm"
        return dateFormatter.string(from: self)
    }
    
    public func getDayOnly() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone(identifier: TimeZone.current.identifier)
        dateFormatter.dateFormat = "dd"
        return dateFormatter.string(from: self)
    }
}

public extension Date {
    
    public func diffrenceTime() -> (Int, Int) {
        var cal = Calendar.init(identifier: .persian)
        let d1 = Date()
        let components = cal.dateComponents([.hour, .minute], from: self, to: d1)
        let diffHour = components.hour!
        let diffMinute = components.minute!
        
        return (diffHour, diffMinute)
    }
    
    public func fullDistance(to date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int? {
        calendar.dateComponents([component], from: self, to: date).value(for: component)
    }
    
    public func fullDistancePositive(to date: Date, resultIn component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let result = calendar.dateComponents([component], from: date, to: self).value(for: component)
        guard result != nil else{
            return 0
        }
        return result!
    }

    public func distance(from date: Date, only component: Calendar.Component, calendar: Calendar = .current) -> Int {
        let days1 = calendar.component(component, from: self)
        let days2 = calendar.component(component, from: date)
        print(days1,days2)
        return days1 - days2
    }

    public func hasSame(_ component: Calendar.Component, as date: Date) -> Bool {
        self.distance(from: date, only: component) == 0
    }
}
