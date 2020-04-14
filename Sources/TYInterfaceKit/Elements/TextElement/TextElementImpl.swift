//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

open class TextElementImpl: ElementView, TextElement {
    
    private let label = UILabel()
   
    public var text: String? {
        didSet {
            updateText()
        }
    }
    
    public var numberOfLines: Int? {
        didSet {
            label.numberOfLines = numberOfLines ?? 0
        }
    }
    
    public var textStyleFactory: TextStyleBuilder? {
        didSet {
            updateText()
        }
    }
    
    public var minimumScaleFactor: Float? {
        didSet {
            if (minimumScaleFactor ?? 0) > 0 {
                label.adjustsFontSizeToFitWidth = true
                label.minimumScaleFactor = CGFloat(minimumScaleFactor!)
            } else {
                label.adjustsFontSizeToFitWidth = false
            }
            updateText()
        }
    }
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        setContentHuggingPriority(.defaultHigh, for: .vertical)
        setupComponents()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateAttributes(forRange range: NSRange, with attributes: [NSAttributedString.Key : Any]) {
        let mutable = (label.attributedText?.mutableCopy() as? NSMutableAttributedString)
        mutable?.setAttributes(attributes, range: range)
        label.attributedText = mutable
    }
    
    private func setupComponents() {
        func setupLabel() {
            label.translatesAutoresizingMaskIntoConstraints = false
            addSubview(label)
            let constraints = [
                label.topAnchor.constraint(equalTo: topAnchor),
                label.rightAnchor.constraint(equalTo: rightAnchor),
                label.bottomAnchor.constraint(equalTo: bottomAnchor),
                label.leftAnchor.constraint(equalTo: leftAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        setupLabel()
    }
    
    private func updateText() {
        guard let text = text else {
            label.text = nil
            return
        }
        
        if let textStyleFactory = textStyleFactory {
            label.attributedText = textStyleFactory.make(text: text)
        } else {
            label.text = text
        }
    }
}
