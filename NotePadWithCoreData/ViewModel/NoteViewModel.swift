//
//  NoteViewModel.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import Foundation

class NoteViewModel{
    var notes:[NoteModel] = [NoteModel]()
    
    init(){
        notes = CoreDB.getInstance().getAllNotes()
    }
    
    func getNotes()-> [NoteModel]{
        return CoreDB.getInstance().getAllNotes()
    }
    
    func addNote(title: String?, desc: String?, date: Date?)-> Bool {
        let newN = NoteModel(entity: CoreDB.getInstance().notesEntity, insertInto: CoreDB.getInstance().context)
        newN.title = title
        newN.desc = desc
        newN.date = date
        
        return saveNotes()
    }
    
    func updateNote(note: NoteModel, title: String?, desc: String?, date: Date?)->Bool{
        note.title = title
        note.desc = desc
        note.date = date
        
        return saveNotes()
    }
    
    func deleteNote(note: NoteModel)-> Bool{
        CoreDB.getInstance().context.delete(note)
        return saveNotes()
    }
    
    func saveNotes()-> Bool{
        return CoreDB.getInstance().save()
    }
    
    
}
