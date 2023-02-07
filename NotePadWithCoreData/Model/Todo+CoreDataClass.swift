//
//  Todo+CoreDataClass.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 07/02/2023.
//
//

import Foundation
import CoreData

@objc(Todo)
public class Todo: NSManagedObject {
    func display(){
        print("Todo: \(String(describing: task) ), isDone: \(isDone)")
    }
}
