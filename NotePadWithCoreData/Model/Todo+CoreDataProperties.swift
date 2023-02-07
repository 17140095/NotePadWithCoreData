//
//  Todo+CoreDataProperties.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 07/02/2023.
//
//

import Foundation
import CoreData


extension Todo {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Todo> {
        return NSFetchRequest<Todo>(entityName: "Todo")
    }

    @NSManaged public var task: String?
    @NSManaged public var isDone: Bool

}

extension Todo : Identifiable {

}
