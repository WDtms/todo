//
//  TodoInteractor.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

class TodoInteractor: TodoInteractorProtocol {
    private weak var todoInteractorOutput: TodoInteractorOutputProtocol?
    private let todoRepository: TodoRepositoryProtocol
    private var todoApiManager: TodoApiManager
    
    init(todoRepository: TodoRepositoryProtocol, todoApiManager: TodoApiManager) {
        self.todoRepository = todoRepository
        self.todoApiManager = todoApiManager
    }
    
    func configure(todoInteractorOutput: TodoInteractorOutputProtocol) {
        self.todoInteractorOutput = todoInteractorOutput
    }
    
    func fetchTodoList() {
        let wasFetchedOnce = UserDefaults.standard.bool(forKey: "wasFetched")
                
        wasFetchedOnce ? fetchTodoListFromStorage() : fetchTodoListFromBackend()
    }
    
    func createTodo(todoText: String, isCompleted: Bool) {
        todoRepository.addTodo(todoText: todoText, isCompleted: isCompleted) { [weak self] in
            guard let self = self else { return }
            
            fetchTodoListFromStorage()
        }
    }
    
    func deleteTodo(id: Int) {
        todoRepository.removeTodo(id: id) { [weak self] in
            guard let self = self else { return }
            
            fetchTodoListFromStorage()
        }
    }
    
    func editTodo(id: Int, todoText: String?, isCompleted: Bool?) {
        todoRepository.editTodo(id: id, todoText: todoText, isCompleted: isCompleted) { [weak self] in
            guard let self = self else { return }
            
            fetchTodoListFromStorage()
        }
    }
    
    private func fetchTodoListFromBackend() {
        todoApiManager.fetchTodos { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let entityList):
                UserDefaults.standard.setValue(true, forKey: "wasFetched")
                
                self.todoRepository.saveTodoList(entityList)
                
                self.todoInteractorOutput?.handleFetchedTodoList(todoList: entityList)
            case .failure(_):
                self.todoInteractorOutput?.handleErrorOnFetchingTodoList()
            }
        }
    }
    
    private func fetchTodoListFromStorage() {
        todoRepository.fetchSavedData { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let entityList):
                self.todoInteractorOutput?.handleFetchedTodoList(todoList: entityList)
            case .failure(_):
                self.todoInteractorOutput?.handleErrorOnFetchingTodoList()
            }
        }
    }
}
