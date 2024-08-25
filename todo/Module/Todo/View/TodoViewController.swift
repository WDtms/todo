//
//  TodoViewController.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import UIKit

class TodoViewController: UIViewController {
    private var todoPresenter: TodoPresenterProtocol?
    
    private var errorStateView: TodoErrorStateView?
    private var loadingStateView: TodoLoadingStateView?
    private var loadedStateView: TodoLoadedStateView?
    
    func configure(presenter: TodoPresenterProtocol) {
        self.todoPresenter = presenter
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .secondarySystemBackground
        title = "Todo List"
        
        showLoadingState()
    }
    
    private func showLoadingState() {
        let loadingState = TodoLoadingStateView()
        
        self.loadingStateView = loadingState
        
        view.addSubview(loadingState)
        
        NSLayoutConstraint.activate([
            loadingState.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingState.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingState.topAnchor.constraint(equalTo: view.topAnchor),
            loadingState.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func hideLoadingState() {
        self.loadingStateView?.removeFromSuperview()
        self.loadingStateView = nil
    }
    
    private func showInitialLoadingErrorState() {
        let errorStateView = TodoErrorStateView()
        errorStateView.delegate = self
        
        self.errorStateView = errorStateView
        
        view.addSubview(errorStateView)
        
        NSLayoutConstraint.activate([
            errorStateView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            errorStateView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            errorStateView.topAnchor.constraint(equalTo: view.topAnchor),
            errorStateView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    private func hideErrorView() {
        self.errorStateView?.removeFromSuperview()
        self.errorStateView = nil
    }
    
    private func showLoadedState(todoList: [TodoEntity]) {
        if let loadedState = loadedStateView {
            loadedState.updateTableViewWithData(todoList: todoList)
            
            return
        }
        
        let loadedState = TodoLoadedStateView()
        
        self.loadedStateView = loadedState
        
        loadedState.updateTableViewWithData(todoList: todoList)
        loadedState.delegate = self
        
        view.addSubview(loadedState)
        
        NSLayoutConstraint.activate([
            loadedState.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadedState.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadedState.topAnchor.constraint(equalTo: view.topAnchor),
            loadedState.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}


extension TodoViewController: TodoViewProtocol {
    func showErrorState() {
        hideLoadingState()
        showInitialLoadingErrorState()
    }
    
    func showTodoList(todoList: [TodoEntity]) {
        hideLoadingState()
        showLoadedState(todoList: todoList)
    }
    
    func showCreateTodoAlert() {
        let customAlertVC = CreateTodoAlertViewController { [weak self] todoText, isCompleted in
            guard let self = self else { return }
            
            todoPresenter?.requestCreateTodo(todoText: todoText, isCompleted: isCompleted)
        }
        
        customAlertVC.modalPresentationStyle = .overCurrentContext
        customAlertVC.modalTransitionStyle = .crossDissolve
        present(customAlertVC, animated: true, completion: nil)
    }
    
    func showEditTodoAlert(todo: TodoEntity) {
        let customAlertVC = EditTodoAlertViewController { [weak self] todoText, isCompleted in
            guard let self = self else { return }
            
            todoPresenter?.requestTodoEdition(todo: todo, todoText: todoText, isCompleted: isCompleted)
        }
        
        customAlertVC.configure(with: todo)
        
        customAlertVC.modalPresentationStyle = .overCurrentContext
        customAlertVC.modalTransitionStyle = .crossDissolve
        present(customAlertVC, animated: true, completion: nil)
    }
}

extension TodoViewController: TodoErrorStateViewDelegate {
    func tryAgain() {
        todoPresenter?.initialLoadTodos()
    }
}

extension TodoViewController: TodoLoadedStateViewDelegate {
    func handleTodoToggle(todo: TodoEntity) {
        todoPresenter?.requestTodoToggle(todoText: todo)
    }
    
    func handleLongPress(todo: TodoEntity) {
        todoPresenter?.requestShowEditTodoAlert(todo: todo)
    }
    
    func requestShowCreateTodoAlert() {
        todoPresenter?.requestShowCreateTodoAlert()
    }
    
    func handleTodoDeletion(id: Int) {
        todoPresenter?.requestTodoDeletion(id: id)
    }
}
