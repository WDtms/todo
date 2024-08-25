//
//  CreateTodoAlertViewController.swift
//  Todo
//
//  Created by Aleksey Shepelev on 25.08.2024.
//

import UIKit

class CreateTodoAlertViewController: TodoActionAlertViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func getTitleText() -> String {
        "Todo Creation"
    }
    
    override func getActionButtonText() -> String {
        "Create"
    }
}
