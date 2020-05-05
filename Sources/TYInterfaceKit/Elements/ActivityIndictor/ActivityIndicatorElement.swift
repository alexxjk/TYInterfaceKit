//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 5/5/20.
//

import UIKit

public class ActivityIndicatorElement: ElementView {
    
    private let activityIndicator = UIActivityIndicatorView(style: .large)
    
    var color: UIColor? {
        didSet {
            activityIndicator.color = color
        }
    }
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        setupComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupComponents() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        addSubview(activityIndicator)
        let constraints = [
            activityIndicator.topAnchor.constraint(equalTo: topAnchor),
            activityIndicator.rightAnchor.constraint(equalTo: rightAnchor),
            activityIndicator.bottomAnchor.constraint(equalTo: bottomAnchor),
            activityIndicator.leftAnchor.constraint(equalTo: leftAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
        activityIndicator.startAnimating()
    }
    
}

