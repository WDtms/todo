//
//  TodoPresenterProtocol.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

protocol TodoPresenterProtocol: AnyObject {
    func initialLoadTodos()

    func requestShowCreateTodoAlert()
    
    func requestShowEditTodoAlert(todo: TodoEntity)
    
    func requestCreateTodo(todoText: String, isCompleted: Bool)
    
    func requestTodoToggle(todoText: TodoEntity)
    
    func requestTodoDeletion(id: Int)
    
    func requestTodoEdition(todo: TodoEntity, todoText: String?, isCompleted: Bool?)
}
