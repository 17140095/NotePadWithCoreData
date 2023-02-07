//
//  NoteModel+CoreDataProperties.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 06/02/2023.
//
//

import Foundation
import CoreData


extension NoteModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<NoteModel> {
        return NSFetchRequest<NoteModel>(entityName: "NoteModel")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var date: Date?

}

extension NoteModel : Identifiable {

}
