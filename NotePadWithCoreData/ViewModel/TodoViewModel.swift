//
//  TodoViewModel.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import Foundation

class TodoViewModel{
    func getTodos()-> [Todo] {
        var todo1 = Todo(task: "Get a ride")
        var todo2 = Todo(task: "Walk in a pride")
        var todo3 = Todo(task: "Go home", isCompleted: true)
        var todo4 = Todo(task: "Go to office")
        
        var todos = [Todo]()
        todos.append(todo1)
        todos.append(todo2)
        todos.append(todo3)
        todos.append(todo4)
        
        return todos
    }
    
}
