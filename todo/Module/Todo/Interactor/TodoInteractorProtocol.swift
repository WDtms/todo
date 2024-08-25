//
//  TodoInteractorProtocol.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

protocol TodoInteractorProtocol: AnyObject {
    func fetchTodoList()
    
    func createTodo(todoText: String, isCompleted: Bool)
    
    func deleteTodo(id: Int)
    
    func editTodo(id: Int, todoText: String?, isCompleted: Bool?)
}

protocol TodoInteractorOutputProtocol: AnyObject {
    func handleFetchedTodoList(todoList: [TodoEntity]) 
    
    func handleErrorOnFetchingTodoList()
}
