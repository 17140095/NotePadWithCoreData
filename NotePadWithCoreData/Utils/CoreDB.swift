//
//  CoreDB.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 03/02/2023.
//

import UIKit
import CoreData

class CoreDB{
    var appDelegate: AppDelegate?
    var context: NSManagedObjectContext
    
    var notesEntity: NSEntityDescription
    
    private let ENTITY_NOTE = "NoteModel"
    private let ENTITY_TODO = "TodoModel"
    
    private static let instance = CoreDB()
    
    private init(){
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = (appDelegate?.persistentContainer.viewContext)!
        self.notesEntity = NSEntityDescription.entity(forEntityName: ENTITY_NOTE, in: context)!
        //deleteAllNotes()
    }
    
    static func getInstance()-> CoreDB {
        instance
    }
    
    func deleteAllNotes(){
    
        let fetchRequest = NoteModel.fetchRequest()
        do{
            let result = try context.fetch(fetchRequest)
            for r in result {
                context.delete(r)
            }

            try context.save()
        }catch {
            print("Could not delete all")
        }
    }
    
    func getAllNotes()->[NoteModel] {
        print("Read all notes")
        var temp = [NoteModel]()
        
        do {
            let fetchRequest =  NoteModel.fetchRequest()
            print("fetch Request: \(fetchRequest)")
            temp = try context.fetch(fetchRequest)
        }catch{
            print("Retrieve failded")
        }
        
        return temp
    }

    func save()->Bool{
        do{
            try context.save()
            return true
        }catch let error {
            print("Note saved db: \(error), ")
        }
        return false
    }
    
}

struct EntityNote{
    static let id = "id"
    static let title = "title"
    static let description = "desc"
    static let date = "date"
}
//
//struct EntityTodo{
//    static let title = "title"
//    static let description = "desc"
//    static let date = "date"
//}
