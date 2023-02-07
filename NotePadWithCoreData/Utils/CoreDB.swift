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
    
    func getAllNotes()->[NoteModel]{
        context.reset()
        print("Read all notes")
        var temp = [NoteModel]()
        
        let fetchRequest =  NoteModel.fetchRequest()
        print("fetch Request: \(fetchRequest)")
        
        
        do {
            let result = try context.fetch(fetchRequest)
            
            for data in result  {
                let title = data.value(forKey: EntityNote.title) as! String?
                let desc = data.value(forKey: EntityNote.description) as! String
                let date = data.value(forKey: EntityNote.date) as? Date
                let id = data.value(forKey: EntityNote.id) as? UUID
                
                let n = NoteModel(entity: notesEntity, insertInto: context)
                n.title = title
                n.desc = desc
                n.date = date
                n.id = id
                
                temp.append(n)
            }
        }catch{
            print("Retrieve failded")
        }
        
        
        return temp
    }
    
    func saveNote(note: NoteModel)-> Bool{
        var toReturn: Bool = true
        
        print(note)
        if let noteEntity = NSEntityDescription.entity(forEntityName: ENTITY_NOTE, in: context){
            let noteToSave = NSManagedObject(entity: noteEntity, insertInto: context)
            noteToSave.setValue(note.title, forKey: EntityNote.title)
            noteToSave.setValue(note.desc, forKey: EntityNote.description)
            noteToSave.setValue(note.date, forKey: EntityNote.date)
            noteToSave.setValue(note.id, forKey: EntityNote.id)
            
            do{
                try context.save()
            }catch let error as NSError{
                print("Could not save. \(error), \(error.userInfo)")
                toReturn = false
            }
        }
        return toReturn
    }
    
    func updateNote(note: NoteModel, with: NoteModel)->Bool{
        var toReturn = true
        
        
      
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: ENTITY_NOTE)
            
            let predicate = NSPredicate(format: "id = %@", with.id as! CVarArg )
            fetchRequest.predicate = predicate
//            let firstPredicate = NSPredicate(format: "\(EntityNote.title) = %@", with.title ?? "")
//            let secondPredicate = NSPredicate(format: "\(EntityNote.description) = %@", with.description )
//            let thirdPredicate = NSPredicate(format: "\(EntityNote.date) = %@", Utils.getStringFromDate(date: with.dateTime) ?? "")
//
//            fetchRequest.predicate = NSCompoundPredicate(orPredicateWithSubpredicates: [firstPredicate, secondPredicate, thirdPredicate])
//
            do {
                let result = try context.fetch(fetchRequest)
                
                let obj = result[0] as! NSManagedObject
                obj.setValue(note.title, forKey: EntityNote.title)
                obj.setValue(note.desc, forKey: EntityNote.description)
                obj.setValue(note.date, forKey: EntityNote.date)
                obj.setValue(note.id, forKey: EntityNote.id)
                
                try context.save()
            }catch{
                print("Update record failded")
            }
        
        
        return toReturn
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
