//
//  TodoDto.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation

struct TodoResponse: Decodable {
    let todos: [TodoDto]
}

struct TodoDto: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
}
