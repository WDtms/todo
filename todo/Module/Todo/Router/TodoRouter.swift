//
//  TodoRouter.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

class TodoRouter: TodoRouterProtocol {
    private weak var todoView: TodoViewController?
    
    func configure(view: TodoViewController) {
        self.todoView = view
    }
    
    static func createModule() -> any TodoViewProtocol {
        let view = TodoViewController()
        let presenter = TodoPresenter()
        let interactor = TodoInteractor(todoRepository: TodoRepository(), todoApiManager: TodoApiManager())
        let router = TodoRouter()
        
        presenter.configure(todoView: view, todoInteractor: interactor)
        interactor.configure(todoInteractorOutput: presenter)
        view.configure(presenter: presenter)
        router.configure(view: view)
        
        presenter.initialLoadTodos()
        
        return view
    }
}
