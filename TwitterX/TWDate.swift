//
//  TWDate.swift
//  Twitter
//
//  Created by Tien on 3/27/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import Foundation

extension NSDate {
    func stringDifferentFrom(date: NSDate) -> String {
        let timestamp = Int(self.timeIntervalSince1970)
        let laterTimestamp = Int(date.timeIntervalSince1970)
        let diff = timestamp - laterTimestamp
        
        let year = diff / (365*24*3600)
        let month = diff / (30 * 24 * 3600)
        let day = diff / (24 * 3600)
        let hour = diff / 3600
        let min = diff / 60
        let sec = diff
        
        if year > 0 {
            return "\(year)y"
        } else if month > 0 {
            return "\(month)m"
        } else if day > 0 {
            return "\(day)d"
        } else if hour > 0 {
            return "\(hour)h"
        } else if min > 0 {
            return "\(min)m"
        } else {
            return "\(sec)s"
        }
    }
}