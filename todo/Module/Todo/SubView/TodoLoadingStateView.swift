//
//  TodoLoadingStateView.swift
//  todo
//
//  Created by Aleksey Shepelev on 23.08.2024.
//

import UIKit

class TodoLoadingStateView: UIView {

    let loadingIndicatorView = UIActivityIndicatorView(style: .large)

    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUi()
    }
    
    private func setupUi() {
        translatesAutoresizingMaskIntoConstraints = false
        
        loadingIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        loadingIndicatorView.color = .label
        
        addSubview(loadingIndicatorView)
        
        NSLayoutConstraint.activate([
            loadingIndicatorView.centerXAnchor.constraint(equalTo: centerXAnchor),
            loadingIndicatorView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        
        loadingIndicatorView.startAnimating()
    }
}
