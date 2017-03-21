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
        let dateString = dateFormatter.string(from:date)
        
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
}
