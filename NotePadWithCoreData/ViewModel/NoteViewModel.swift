//
//  NoteViewModel.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import Foundation

class NoteViewModel{
    var notes:[Note] = [Note]()
    
    init(){
        let not1:Note = Note(title: "This is title", description: "This is description")
        let not2:Note = Note(title: nil, description: "This is description")
        let not3:Note = Note(title: nil, description: "This description")
        
        
        notes.append(not1)
        notes.append(not3)
        notes.append(not2)
    }
    
    func getNotes()-> [Note]{
        return notes
    }
    
}
