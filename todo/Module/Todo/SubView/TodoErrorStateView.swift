//
//  TodoErrorStateView.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import UIKit

protocol TodoErrorStateViewDelegate {
    func tryAgain()
}

class TodoErrorStateView: UIView {
    
    var delegate: TodoErrorStateViewDelegate?
    
    private let horizontalPadding: CGFloat = 32
    
    private let errorMessageLabel = UILabel()
    private let tryAgainButton = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUi()
    }
    
    private func setupUi() {
        translatesAutoresizingMaskIntoConstraints = false
        
        configureErrorMessageLabel()
        configureTryAgainButton()
        
        configureLayout()
    }
    
    private func configureErrorMessageLabel() {
        errorMessageLabel.translatesAutoresizingMaskIntoConstraints = false
        
        errorMessageLabel.textAlignment = .center
        errorMessageLabel.font = .systemFont(ofSize: 26)
        errorMessageLabel.textColor = .secondaryLabel
        errorMessageLabel.numberOfLines = 0
        errorMessageLabel.text = "Oops! Something went wrong. Try again please."
    }
    
    private func configureTryAgainButton() {
        tryAgainButton.translatesAutoresizingMaskIntoConstraints = false
        
        let labelHorizontalPadding: CGFloat = 24
        let labelVerticalPadding: CGFloat = 16
        
        var buttonConfiguration = UIButton.Configuration.filled()
        buttonConfiguration.baseBackgroundColor = .label
        buttonConfiguration.baseForegroundColor = .systemBackground
        buttonConfiguration.contentInsets = NSDirectionalEdgeInsets(top: labelVerticalPadding, leading: labelHorizontalPadding, bottom: labelVerticalPadding, trailing: labelHorizontalPadding)
        buttonConfiguration.cornerStyle = .medium
        buttonConfiguration.title = "Try Again"
        
        tryAgainButton.configuration = buttonConfiguration
        tryAgainButton.addTarget(self, action: #selector(onButtonTapped), for: .touchUpInside)
    }

    private func configureLayout() {
        addSubview(errorMessageLabel)
        addSubview(tryAgainButton)
        
        NSLayoutConstraint.activate([
            errorMessageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: horizontalPadding),
            errorMessageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -horizontalPadding),
            errorMessageLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            errorMessageLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            tryAgainButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            tryAgainButton.topAnchor.constraint(equalTo: errorMessageLabel.bottomAnchor, constant: 24),
        ])
    }
    
    @objc private func onButtonTapped() {
        delegate?.tryAgain()
    }
}
