//
//  TodoViewModel.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import Foundation

class TodoViewModel{
    private var todos:[Todo]
    
    init(){
        todos = CoreDB.getInstance().getAllTodos()
    }
    func getTodos()-> [Todo] {
        //todos = CoreDB.getInstance().getAllTodos()
        
        let todo1 = Todo(entity: CoreDB.getInstance().todosEntity, insertInto: CoreDB.getInstance().context)
        todo1.task = "Get a ride of card"
        
        let todo2 = Todo(entity: CoreDB.getInstance().todosEntity, insertInto: CoreDB.getInstance().context)
        todo2.task = "My first job"
        
        
        var todos = [Todo]()
        todos.append(todo1)
        todos.append(todo2)
        
        return todos
    }
    func getCompletedTodo()-> [Todo]{
        todos.filter { todo in
            todo.isDone
        }
    }
    func getUncompletedTodo()->[Todo]{
        todos.filter { todo in
            !todo.isDone
        }
    }
    
    
}
