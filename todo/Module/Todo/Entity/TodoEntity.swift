//
//  TodoModel.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

struct TodoEntity: Codable {
    let id: Int
    let todo: String
    let isCompleted: Bool
    let creationDate: Date
}

extension TodoDto {
    func toEntity() -> TodoEntity {
        TodoEntity(id: self.id, todo: self.todo, isCompleted: self.completed, creationDate: Date.now)
    }
}
