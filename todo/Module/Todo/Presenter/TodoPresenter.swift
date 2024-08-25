//
//  TodoPresenter.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

class TodoPresenter: TodoPresenterProtocol {
    private weak var todoView: TodoViewProtocol?
    private var todoInteractor: TodoInteractorProtocol?
    
    func configure(todoView: TodoViewProtocol, todoInteractor: TodoInteractorProtocol) {
        self.todoView = todoView
        self.todoInteractor = todoInteractor
    }
    
    func initialLoadTodos() {
        todoInteractor?.fetchTodoList()
    }
    
    func requestCreateTodo(todoText: String, isCompleted: Bool) {
        todoInteractor?.createTodo(todoText: todoText, isCompleted: isCompleted)
    }
    
    func requestTodoDeletion(id: Int) {
        todoInteractor?.deleteTodo(id: id)
    }
    
    func requestTodoToggle(todoText: TodoEntity) {
        todoInteractor?.editTodo(id: todoText.id, todoText: nil, isCompleted: !todoText.isCompleted)
    }
    
    func requestTodoEdition(todo: TodoEntity, todoText: String?, isCompleted: Bool?) {
        var changedText: String?
        var changedIsCompleted: Bool?
        
        if todoText != todo.todo {
            changedText = todoText
        }
        
        if isCompleted != todo.isCompleted {
            changedIsCompleted = isCompleted
        }
        
        if changedText == nil && changedIsCompleted == nil {
            return
        }
        
        todoInteractor?.editTodo(id: todo.id, todoText: changedText, isCompleted: changedIsCompleted)
    }
    
    func requestShowCreateTodoAlert() {
        todoView?.showCreateTodoAlert()
    }
    
    func requestShowEditTodoAlert(todo: TodoEntity) {
        todoView?.showEditTodoAlert(todo: todo)
    }
}

extension TodoPresenter: TodoInteractorOutputProtocol {
    func handleFetchedTodoList(todoList: [TodoEntity]) {
        todoView?.showTodoList(todoList: todoList)
    }
    
    func handleErrorOnFetchingTodoList() {
        todoView?.showErrorState()
    }
}
