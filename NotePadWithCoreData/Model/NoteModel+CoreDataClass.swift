//
//  NoteModel+CoreDataClass.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 06/02/2023.
//
//

import Foundation
import CoreData

@objc(NoteModel)
public class NoteModel: NSManagedObject {

    public func setTitle(title: String?){
        self.title = title
    }
    
    public func display(){
        print("Id: \(self.id), Title: \(self.title), Date: \(Utils.getStringFromDate(date: self.date ?? Date())), Desc: \(self.desc)")
    }
}
