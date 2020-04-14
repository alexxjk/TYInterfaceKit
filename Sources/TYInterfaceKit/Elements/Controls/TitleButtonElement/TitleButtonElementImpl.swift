//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

open class TitleButtonElementImpl: ElementControl, TitleButtonElement {

    private let label = TextElementImpl(configurator: ElementViewConfigurator())

    public var title: String {
        set {
            label.text = newValue
        }
        get {
            return label.text ?? ""
        }
    }
    
    public var textStyleFactory: TextStyleBuilder? {
        didSet {
            label.textStyleFactory = textStyleFactory
        }
    }

    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        setupElements()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupElements() {
        
        func setupLabel() {
            addSubview(label)
            label.isUserInteractionEnabled = false
            let constraints = [
                label.topAnchor.constraint(equalTo: topAnchor),
                label.trailingAnchor.constraint(equalTo: trailingAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                label.leadingAnchor.constraint(equalTo: leadingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        setupLabel()
    }
}

