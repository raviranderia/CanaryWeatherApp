//
//  WeekOperation.swift
//  weatherApp
//
//  Created by RAVI RANDERIA on 4/5/16.
//  Copyright © 2016 RAVI RANDERIA. All rights reserved.
//

import Foundation

struct WeekOperation {
    
    enum getDate : Int {
    case Monday = 1
    case Tuesday
    case Wednesday
    case Thursday
    case Friday
    case Saturday
    case Sunday
    }
    
    func getDayOfWeek(date : Double)->String? {
        
        let date = NSDate(timeIntervalSince1970: NSTimeInterval.abs(date))
        let todayDate = date
        let myCalendar = NSCalendar(calendarIdentifier: NSGregorianCalendar)
        let myComponents = myCalendar?.components(.NSWeekdayCalendarUnit, fromDate: todayDate)
        let weekDay = myComponents?.weekday
        if let weekDay = weekDay {
            return String(getDate(rawValue: weekDay)!)
        }
        else{
            return nil
        }
    }
}