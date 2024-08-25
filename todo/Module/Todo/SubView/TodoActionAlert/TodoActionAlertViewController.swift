//
//  TodoActionAlertViewController.swift
//  Todo
//
//  Created by Aleksey Shepelev on 25.08.2024.
//

import UIKit

class TodoActionAlertViewController: UIViewController {
    private let action: (String, Bool) -> Void
    
    private let alertView = UIView()
    private let alertTitleLabel = UILabel()
    private let completionTextLabel = UILabel()
    private let createButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)
    
    internal let completionSwitch = UISwitch()
    internal let textField = UITextField()
    
    init(action: @escaping (String, Bool) -> Void) {
        self.action = action
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUi()
    }
    
    private func setupUi() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.2)
        
        configureOutsideGesturesHandling()
        
        configureAlertView()
        configureTitleView()
        configureTextField()
        configureCompletionSwitch()
        configureCompletionTextLabel()
        configureCreateButton()
        configureCancelButton()
        
        configureLayout()
    }
    
    private func configureOutsideGesturesHandling() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapOutside))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc private func handleTapOutside(_ sender: UITapGestureRecognizer) {
        let location = sender.location(in: self.view)
        if !alertView.frame.contains(location) {
            closeAlert()
        }
    }
    
    private func configureAlertView() {
        alertView.translatesAutoresizingMaskIntoConstraints = false
        alertView.backgroundColor = .white
        alertView.layer.cornerRadius = 12
    }
    
    private func configureTitleView() {
        alertTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        alertTitleLabel.text = getTitleText()
    }
    
    private func configureTextField() {
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.borderStyle = .roundedRect
        textField.placeholder = "Enter todo"
    }
    
    private func configureCompletionTextLabel() {
        completionTextLabel.translatesAutoresizingMaskIntoConstraints = false
        completionTextLabel.text = "Todo Completion"
    }
    
    private func configureCompletionSwitch() {
        completionSwitch.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureCreateButton() {
        createButton.setTitle(getActionButtonText(), for: .normal)
        createButton.addTarget(self, action: #selector(createTodo), for: .touchUpInside)
        configureButton(buttonToConfigure: createButton)
    }
    
    private func configureCancelButton() {
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        configureButton(buttonToConfigure: cancelButton)
    }
    
    private func configureButton(buttonToConfigure: UIButton) {
        buttonToConfigure.translatesAutoresizingMaskIntoConstraints = false
        buttonToConfigure.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        buttonToConfigure.setTitleColor(.systemBlue, for: .normal)
    }
    
    @objc private func createTodo() {
        dismiss(animated: true) { [weak self] in
            guard let self = self else { return }
            
            let text = textField.text ?? ""
            let isCompleted = completionSwitch.isOn
            
            action(text, isCompleted)
        }
    }
    
    @objc private func closeAlert() {
        dismiss(animated: true)
    }
    
    private func configureLayout() {
        view.addSubview(alertView)
        
        alertView.addSubview(alertTitleLabel)
        
        let titleDivider = UIView()
        titleDivider.backgroundColor = .systemGray5
        titleDivider.translatesAutoresizingMaskIntoConstraints = false
        
        alertView.addSubview(titleDivider)
        
        alertView.addSubview(textField)
        alertView.addSubview(completionTextLabel)
        alertView.addSubview(completionSwitch)
        
        let buttonDivider = UIView()
        buttonDivider.backgroundColor = .systemGray5
        buttonDivider.translatesAutoresizingMaskIntoConstraints = false
        alertView.addSubview(buttonDivider)
        
        alertView.addSubview(createButton)
        alertView.addSubview(cancelButton)
        
        NSLayoutConstraint.activate([
            alertView.widthAnchor.constraint(equalToConstant: 250),
            alertView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alertView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            alertTitleLabel.topAnchor.constraint(equalTo: alertView.topAnchor, constant: 10),
            alertTitleLabel.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            
            titleDivider.topAnchor.constraint(equalTo: alertTitleLabel.bottomAnchor, constant: 8),
            titleDivider.widthAnchor.constraint(equalTo: alertView.widthAnchor),
            titleDivider.heightAnchor.constraint(equalToConstant: 0.4),
            
            textField.topAnchor.constraint(equalTo: titleDivider.bottomAnchor, constant: 20),
            textField.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            textField.leadingAnchor.constraint(equalTo: alertView.leadingAnchor, constant: 10),
            textField.trailingAnchor.constraint(equalTo: alertView.trailingAnchor, constant: -10),
            
            completionSwitch.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 12),
            completionSwitch.trailingAnchor.constraint(equalTo: textField.trailingAnchor),
            
            completionTextLabel.bottomAnchor.constraint(equalTo: completionSwitch.bottomAnchor),
            completionTextLabel.leadingAnchor.constraint(equalTo: textField.leadingAnchor),
            
            buttonDivider.topAnchor.constraint(equalTo: completionTextLabel.bottomAnchor, constant: 20),
            buttonDivider.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            buttonDivider.trailingAnchor.constraint(equalTo: alertView.trailingAnchor),
            buttonDivider.heightAnchor.constraint(equalToConstant: 0.4),
            
            cancelButton.topAnchor.constraint(equalTo: buttonDivider.bottomAnchor),
            cancelButton.leadingAnchor.constraint(equalTo: alertView.leadingAnchor),
            cancelButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.5),
            cancelButton.heightAnchor.constraint(equalToConstant: 54),
                        
            createButton.topAnchor.constraint(equalTo: cancelButton.topAnchor),
            createButton.leadingAnchor.constraint(equalTo: cancelButton.trailingAnchor),
            createButton.heightAnchor.constraint(equalToConstant: 54),
            createButton.widthAnchor.constraint(equalTo: alertView.widthAnchor, multiplier: 0.5),
        ])
        
        alertView.bottomAnchor.constraint(equalTo: cancelButton.bottomAnchor).isActive = true
    }
    
    internal func getTitleText() -> String {
        "Todo"
    }
    
    internal func getActionButtonText() -> String {
        "Create"
    }
}
