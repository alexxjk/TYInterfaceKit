//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ContainerElementImpl: ElementView, ContainerElement {
    
    public var clip: Bool {
        get {
            return clipsToBounds
        }
        set {
            clipsToBounds = newValue
        }
    }
    
    public var paddings: NSDirectionalEdgeInsets? {
        set {
            if let contentView = contentView {
                contentView.directionalLayoutMargins = newValue ?? .zero
            } else {
                directionalLayoutMargins = newValue ?? .zero
            }
        }
        get {
            if let contentView = contentView {
                return contentView.directionalLayoutMargins
            } else {
                return directionalLayoutMargins
            }
        }
    }
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        clipsToBounds = true
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .horizontal)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        removeAllElements()
    }
}

