//
//  TodoViewModel.swift
//  NotePadWithCoreData
//
//  Created by Ali Raza on 30/01/2023.
//

import Foundation

class TodoViewModel{
  
    func getTodos()-> [Todo] {
        let todo1 = Todo(entity: CoreDB.getInstance().todosEntity, insertInto: CoreDB.getInstance().context)
        todo1.task = "Get a ride of card"
        
        let todo2 = Todo(entity: CoreDB.getInstance().todosEntity, insertInto: CoreDB.getInstance().context)
        todo2.task = "My first job"
        
        let todo3 = Todo(entity: CoreDB.getInstance().todosEntity, insertInto: CoreDB.getInstance().context)
        todo3.task = "My hitchhiking"
        todo3.isDone = true
        
        var todos = [Todo]()
        todos.append(todo1)
        todos.append(todo2)
        todos.append(todo3)
        return todos
    }
    func getCompletedTodo(todos: [Todo])-> [Todo]{
        todos.filter { todo in
            todo.isDone
        }
    }
    func getUncompletedTodo(todos: [Todo])->[Todo]{
        todos.filter { todo in
            !todo.isDone
        }
    }
    
    
}
