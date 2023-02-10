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
    var todosEntity: NSEntityDescription
    
    private let ENTITY_NOTE = "NoteModel"
    private let ENTITY_TODO = "Todo"
    
    private static let instance = CoreDB()
    
    private init(){
        self.appDelegate = UIApplication.shared.delegate as? AppDelegate
        self.context = (appDelegate?.persistentContainer.viewContext)!
        self.notesEntity = NSEntityDescription.entity(forEntityName: ENTITY_NOTE, in: context)!
        self.todosEntity = NSEntityDescription.entity(forEntityName: ENTITY_TODO, in: context)!
        //deleteAllNotes()
        //deleteAllTodos()
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
            print("Could not delete all notes")
        }
    }
    func deleteAllTodos(){
    
        let fetchRequest = Todo.fetchRequest()
        do{
            let result = try context.fetch(fetchRequest)
            for r in result {
                context.delete(r)
            }

            try context.save()
        }catch {
            print("Could not delete all Todos")
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
            print("Retrieve notes failded")
        }
        
        return temp
    }
    
    func getAllTodos()-> [Todo]{
        print("Real all todos")
        var temp = [Todo]()
        
        do{
            let fetchRequest = Todo.fetchRequest()
            print("Fetch Request: \(fetchRequest)")
            temp = try context.fetch(fetchRequest)
        }catch{
            print("Retrieve todos failed")
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

struct EntityTodo{
    static let task = "task"
    static let isDone = "isDone"
}
