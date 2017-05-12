//
//  utils.swift
//  medical
//
//  Created by Luay Suarna on 3/13/17.
//  Copyright © 2017 Luay Suarna. All rights reserved.
//

import Foundation

class Utils {
    
    class public func dateToString(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = dateFormatter.string(from: date)
        
        return dateString
    }
    
    class public func stringToDate(_ string: String) -> Date {
        if string == "0000-00-00 00:00:00" {
            return Date()
        } else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let date = dateFormatter.date(from: string)!
            
            return date
        }
    }
    
    class public func currentDateInString() -> String {
        
        let date = self.stringToDate("0000-00-00 00:00:00")
        
        return self.dateToString(date)
    }
    
    class public func timeAgo(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        let result = dateFormatter.timeSince(from: date as NSDate, numericDates: true)
        
        return result
    }
    
    class public func numberToCurrency(_ double: Double) -> String {
        return String(format: "$%.02f", locale: Locale.current, arguments: [double])
    }
}
