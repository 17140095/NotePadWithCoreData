//
//  Note.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import Foundation

class Note{
    var title: String?
    var description: String
    var dateTime: Date
    
    init(title: String?, description: String, dateTime: Date = Date.now) {
        self.title = title
        self.description = description
        self.dateTime = dateTime
    }
    func display(){
        print("Title: \(String(describing: title)), Desc: \(description), date: \(String(describing: Utils.getStringFromDate(date: dateTime)))")
    }
}
