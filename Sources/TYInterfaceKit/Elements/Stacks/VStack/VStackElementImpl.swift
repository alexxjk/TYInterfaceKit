//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public class VStackElementImpl: ElementView, VStackElement {
    
    private let stack = UIStackView()
    
    public var spacing: Float {
        set {
            stack.spacing = CGFloat(newValue)
        }
        get {
            return Float(stack.spacing)
        }
    }
    
    public var clip: Bool {
        get {
            return clipsToBounds
        }
        set {
            clipsToBounds = newValue
        }
    }
    
    public var topPadding: Float = 0
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setup() {
        func setupStack() {
            stack.translatesAutoresizingMaskIntoConstraints = false
            stack.axis = .vertical
            stack.distribution = .fill
            stack.spacing = CGFloat(spacing)
            //stack.layoutMargins = .zero
            stack.directionalLayoutMargins = .zero
            stack.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins

            addSubview(stack)
            let constraints = [
                stack.topAnchor.constraint(equalTo: topAnchor, constant: CGFloat(topPadding)),
                stack.rightAnchor.constraint(equalTo: rightAnchor),
                stack.bottomAnchor.constraint(equalTo: bottomAnchor),
                stack.leftAnchor.constraint(equalTo: leftAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        super.setup()
        setupStack()
    }
    
    public override func onAppearing() {
        super.onAppearing()
        children.forEach { $0.onAppearing() }
    }
    
    public override func onAppeared() {
        super.onAppeared()
        children.forEach { $0.onAppeared() }
    }
    
    public func removeAllChildren() {
        stack.arrangedSubviews.forEach { [unowned self] in
            self.stack.removeArrangedSubview($0)
        }
        removeAllElements()
    }
    
    override func addElement(element: ElementView) {
        if let heightConstant = element.proxy.heightToSet {
            let heightConstraint = element.heightAnchor.constraint(equalToConstant: CGFloat(heightConstant))
            heightConstraint.priority = .defaultHigh
            heightConstraint.isActive = true
        }

        children.append(element)
        stack.addArrangedSubview(element)
        element.setup()
    }
    
    override func addElement(element: ElementControl) {
        if let heightConstant = element.proxy.heightToSet {
            let heightConstraint = element.heightAnchor.constraint(equalToConstant: CGFloat(heightConstant))
            heightConstraint.priority = .defaultHigh
            heightConstraint.isActive = true
        }

        children.append(element)
        stack.addArrangedSubview(element)
        element.setup()
    }
}

