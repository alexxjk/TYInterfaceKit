//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

open class MultilineTextInputElementImpl: ElementView, TextInputElement, UITextViewDelegate {
    
    private let field = UITextView()
    
    private let placeholder = UILabel()
    
    public var value: String? {
        get {
            return field.text
        } set {
            let oldValue = field.text
            field.text = newValue
            if oldValue != newValue {
                handleValueChanged()
            }
        }
    }
    
    public var textStyleFactory: TextStyleBuilder = .default() {
        didSet {
            setupElements()
        }
    }
    
    public var placeholderText: String? {
        didSet {
            setupElements()
        }
    }
    
    open override var tintColor: UIColor! {
        didSet {
            setupElements()
        }
    }
    
    public override var corners: CornerRadius {
        didSet {
            field.layer.cornerRadius = CGFloat(corners.value)
            var mask = CACornerMask()
            if corners.value > 0 {
               if corners.topRight {
                   mask.insert(.layerMaxXMinYCorner)
               }
               if corners.bottomRight {
                   mask.insert(.layerMaxXMaxYCorner)
               }
               if corners.bottomLeft {
                   mask.insert(.layerMinXMaxYCorner)
               }
               if corners.topLeft {
                   mask.insert(.layerMinXMinYCorner)
               }
            }
            field.layer.maskedCorners = mask
        }
    }
    
    public var doOnValueChanged: (() -> Void)?
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16)
        layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doOnTap))
        addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.alpha = 0.7
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.keyboardAppearance = .dark
        field.autocorrectionType = .no
        field.delegate = self
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func makeFirstResponder() {
        field.becomeFirstResponder()
    }
    
    private func setupElements() {
        

        subviews.forEach {
            $0.removeFromSuperview()
        }
        
        placeholder.attributedText = textStyleFactory.make(text: placeholderText ?? "")
        addSubview(placeholder)
        let placeholderConstraints = [
            placeholder.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            placeholder.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            placeholder.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            placeholder.leadingAnchor.constraint(equalTo: leadingAnchor)
        ]
        NSLayoutConstraint.activate(placeholderConstraints)
        
        field.typingAttributes = textStyleFactory.lineBreakMode(.byWordWrapping).makeAttributes()
        field.tintColor = tintColor
        field.backgroundColor = .clear
        addSubview(field)
        let fieldConstraints = [
            field.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            field.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor),
            field.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            field.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor)
        ]
        NSLayoutConstraint.activate(fieldConstraints)
    }
    
    @objc func doOnTap() {
        field.becomeFirstResponder()
    }
    
    private func replace(currentText: String?, replacementString: String, textRange: NSRange) -> String? {
        guard let currentText = currentText else {
            return nil
        }
        guard let textRange = Range(textRange, in: currentText) else {
            return currentText
        }
        return currentText.replacingCharacters(in: textRange, with: replacementString)
    }
    
    private func handleValueChanged() {
        doOnValueChanged?()
        
        let isValueEmpty = self.value?.isEmpty ?? true
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.placeholder.alpha = isValueEmpty ? 0.7 : 0
        })
    }
    
    @objc private func doOnClearTap() {
        field.text = nil
        handleValueChanged()
    }
}
