//
//  TodoTableViewCell.swift
//  Todo
//
//  Created by Aleksey Shepelev on 24.08.2024.
//

import UIKit

class TodoTableViewCell: UITableViewCell {
    static let identifier = "TodoTableViewCell"
    
    private let todoLabel = UILabel()
    private let dateLabel = UILabel()
    
    private var onPress: (() -> Void)?

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUi()
    }
    
    private func setupUi() {
        selectionStyle = .none
        
        configureTapGesture()
        
        configureDateLabel()
        configureTodoLabel()
        
        configureLayout()
    }
    
    private func configureTapGesture() {
        let pressGesture = UITapGestureRecognizer(target: self, action: #selector(handlePress))
        self.addGestureRecognizer(pressGesture)
    }
    
    @objc private func handlePress() {
        onPress?()
    }
    
    private func configureTodoLabel() {
        todoLabel.translatesAutoresizingMaskIntoConstraints = false
        
        todoLabel.font = UIFont.systemFont(ofSize: 16)
        todoLabel.numberOfLines = 2
    }
    
    private func configureDateLabel() {
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        
        dateLabel.font = UIFont.systemFont(ofSize: 12)
        dateLabel.textColor = .gray
    }
    
    private func configureLayout() {
        addSubview(dateLabel)
        addSubview(todoLabel)
        
        NSLayoutConstraint.activate([
            todoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            todoLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            todoLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -36),
            
            dateLabel.leadingAnchor.constraint(equalTo: todoLabel.leadingAnchor),
            dateLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
    
    func configure(todo: TodoEntity, onPress: (() -> Void)?) {
        todoLabel.text = todo.todo
        dateLabel.text = DateUtils.convertDateToDdMmYyyy(date: todo.creationDate)
        
        accessoryType = todo.isCompleted ? .checkmark : .none
        
        self.onPress = onPress
    }
}
