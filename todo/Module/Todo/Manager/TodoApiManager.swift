//
//  TodoApiManager.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

class TodoApiManager {
    func fetchTodos(completion: @escaping (Result<[TodoEntity], Error>) -> Void) {
        ApiManager.shared.get(path: "/todos") { (result: Result<TodoResponse, Error>) in
            switch result {
            case .success(let todosResponse):
                let entityList = todosResponse.todos.map { $0.toEntity() }
                
                completion(.success(entityList))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
