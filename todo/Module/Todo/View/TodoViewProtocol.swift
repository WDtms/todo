//
//  TodoViewProtocol.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import Foundation
import UIKit

protocol TodoViewProtocol: UIViewController {
    func showErrorState()
    
    func showCreateTodoAlert()
    
    func showEditTodoAlert(todo: TodoEntity)
    
    func showTodoList(todoList: [TodoEntity])
}
