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
//        let not1:Note = Note(title: "Bill of our home", description: "Check this is our bill")
//        let not2:Note = Note(title: nil, description: "There is no title in this note. There is no title in this note. There is no title in this note. ")
//        let not3:Note = Note(title: nil, description: "Type any text")
//        let not4:Note = Note(title: "Factory", description: "Check the status of things")
//
//
//        notes.append(not1)
//        notes.append(not3)
//        notes.append(not2)
//        notes.append(not4)
        notes = CoreDB.getInstance().getAllNotes()
    }
    
    func getNotes()-> [NoteModel]{
        return CoreDB.getInstance().getAllNotes()
    }
    
}
