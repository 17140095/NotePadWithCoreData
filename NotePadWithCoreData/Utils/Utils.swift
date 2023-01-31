//
//  Utils.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 31/01/2023.
//

import Foundation

class Utils{
    private static let FORMAT = "hh:mm a, MMMM d, yyyy"
    
    static func getStringFromDate(date: Date)-> String? {
      
        var formatter = DateFormatter()
        formatter.dateFormat = FORMAT
        
        return formatter.string(from: date)
    }
    static func getDateFromString(from: String)-> Date?{
        var formatter = DateFormatter()
        formatter.dateFormat = FORMAT
        
        return formatter.date(from: from)
    }
}
