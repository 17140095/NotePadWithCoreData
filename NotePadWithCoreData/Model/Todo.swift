//
//  Todo.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import Foundation

class Todo {
    var task: String
    var isCompleted: Bool
    
    init(task: String, isCompleted: Bool = false) {
        self.task = task
        self.isCompleted = isCompleted
    }
}
