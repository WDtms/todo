//
//  TodoLoadedStateView.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import UIKit

protocol TodoLoadedStateViewDelegate {
    func handleTodoDeletion(id: Int)
    
    func handleTodoToggle(todo: TodoEntity)
    
    func requestShowCreateTodoAlert()
    
    func handleLongPress(todo: TodoEntity)
}

class TodoLoadedStateView: UIView {
    private var todoList: [TodoEntity] = []
    
    private let todoTableView = UITableView()
    private let addTodoButton = UIButton()
    
    var delegate: TodoLoadedStateViewDelegate?

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUi()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func updateTableViewWithData(todoList: [TodoEntity]) {
        self.todoList = todoList
        todoTableView.reloadData()
    }
    
    private func setupUi() {
        translatesAutoresizingMaskIntoConstraints = false
        
        configureTableView()
        configureFloatingButton()
        
        configureLayout()
    }
    
    private func configureTableView() {
        todoTableView.translatesAutoresizingMaskIntoConstraints = false
        
        todoTableView.delegate = self
        todoTableView.dataSource = self
        todoTableView.register(TodoTableViewCell.self, forCellReuseIdentifier: TodoTableViewCell.identifier)
    }
    
    private func configureFloatingButton() {
        addTodoButton.translatesAutoresizingMaskIntoConstraints = false
        
        addTodoButton.backgroundColor = .systemBlue
        addTodoButton.setTitle("+", for: .normal)
        addTodoButton.setTitleColor(.white, for: .normal)
        addTodoButton.titleLabel?.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        addTodoButton.layer.cornerRadius = 30
        addTodoButton.clipsToBounds = true
        
        addTodoButton.addTarget(self, action: #selector(addTodoButtonTapped), for: .touchUpInside)
    }
    
    private func configureLayout() {
        addSubview(todoTableView)
        addSubview(addTodoButton)
        
        NSLayoutConstraint.activate([
            todoTableView.topAnchor.constraint(equalTo: topAnchor),
            todoTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            todoTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            todoTableView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            addTodoButton.widthAnchor.constraint(equalToConstant: 60),
            addTodoButton.heightAnchor.constraint(equalToConstant: 60),
            addTodoButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            addTodoButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func addTodoButtonTapped() {
        delegate?.requestShowCreateTodoAlert()
    }
}

extension TodoLoadedStateView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TodoTableViewCell.identifier, for: indexPath) as? TodoTableViewCell else {
            return UITableViewCell()
        }
        
        let todo = self.todoList[indexPath.row]
        
        cell.configure(todo: todo) { [weak self] in
            guard let self = self else { return }
            
            self.delegate?.handleLongPress(todo: todo)
        }

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let isCompleted = self.todoList[indexPath.row].isCompleted
        
        let toggleCompletionAction = UIContextualAction(style: .normal, title: isCompleted ? "Uncomplete" : "Complete") { [weak self]
            (action, view, completionHandler) in
            guard let self = self else { return }
            
            self.delegate?.handleTodoToggle(todo: self.todoList[indexPath.row])
            
            completionHandler(true)
        }
        
        toggleCompletionAction.backgroundColor = .systemBlue
        
        return UISwipeActionsConfiguration(actions: [toggleCompletionAction])
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            delegate?.handleTodoDeletion(id: self.todoList[indexPath.row].id)
        }
    }
}
