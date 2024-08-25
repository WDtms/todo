//
//  EditTodoAlertViewController.swift
//  Todo
//
//  Created by Aleksey Shepelev on 25.08.2024.
//

import UIKit

class EditTodoAlertViewController: TodoActionAlertViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override internal func getTitleText() -> String {
        "Todo Edition"
    }

    override internal func getActionButtonText() -> String {
        "Edit"
    }
    
    func configure(with todo: TodoEntity) {
        textField.text = todo.todo
        completionSwitch.isOn = todo.isCompleted
    }
}
