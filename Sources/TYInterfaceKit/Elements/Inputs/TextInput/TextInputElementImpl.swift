//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

open class TextInputElementImpl: ElementView, SinglelineTextInputElement, UITextFieldDelegate {
    
    private var timer: Timer!
    
    private var shouldFireOnValueChanged = false
    
    private let field = UITextField()
    
    private let placeholder = UILabel()
    
    private let iconHolder = UIImageView()
    
    private let actionButton = IconButtonElementImpl(configurator: ElementViewConfigurator())
    
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
    
    public var allowedCharacters: String?
    
    var clearButtonIcon: UIImage? {
        didSet {
            setupElements()
        }
    }
    
    public var icon: UIImage? {
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
    
    public var doOnValueChanged: (() -> Void)?
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        setContentHuggingPriority(.defaultLow, for: .horizontal)
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 24, bottom: 9, trailing: 8)
        layoutMargins = UIEdgeInsets(top: 10, left: 24, bottom: 9, right: 8)
       
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(doOnTap))
        addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
        
        iconHolder.translatesAutoresizingMaskIntoConstraints = false
        iconHolder.contentMode = .center
        
        placeholder.translatesAutoresizingMaskIntoConstraints = false
        placeholder.alpha = 0.7
        
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        field.keyboardAppearance = .dark
        field.autocorrectionType = .no
        
        self.actionButton.isHidden = self.value?.isEmpty ?? true
        actionButton.doOnTap = { [unowned self] in
            self.doOnClearTap()
        }
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                return
            }
            if self.shouldFireOnValueChanged {
                self.doOnValueChanged?()
            }
            self.shouldFireOnValueChanged = false
        })
        timer.fire()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        timer.invalidate()
    }
    
    public func makeFirstResponder() {
        field.becomeFirstResponder()
    }
    
    private func setupElements() {
        
        func addIcon() {
            if let icon = icon {
                iconHolder.image = icon
                addSubview(iconHolder)
                let iconHolderConstraints = [
                    iconHolder.widthAnchor.constraint(equalToConstant: 24),
                    iconHolder.heightAnchor.constraint(equalToConstant: 24),
                    iconHolder.leadingAnchor.constraint(equalTo: layoutMarginsGuide.leadingAnchor),
                    iconHolder.centerYAnchor.constraint(equalTo: centerYAnchor)
                ]
                NSLayoutConstraint.activate(iconHolderConstraints)
            }
        }
        
        func addActionButton() {
            if let icon = clearButtonIcon {
                actionButton.icon = icon
            }
            addSubview(actionButton)
            let constraints = [
                actionButton.widthAnchor.constraint(equalToConstant: 20),
                actionButton.heightAnchor.constraint(equalToConstant: 20),
                actionButton.centerYAnchor.constraint(equalTo: centerYAnchor),
                actionButton.trailingAnchor.constraint(equalTo: layoutMarginsGuide.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            
        }
        
        subviews.forEach {
            $0.removeFromSuperview()
        }
        
        addIcon()
        addActionButton()
        
        placeholder.attributedText = textStyleFactory.make(text: placeholderText ?? "")
        addSubview(placeholder)
        let placeholderConstraints = [
            placeholder.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            placeholder.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -10),
            placeholder.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            icon != nil ?
                placeholder.leadingAnchor.constraint(equalTo: iconHolder.trailingAnchor, constant: 12) :
                placeholder.leadingAnchor.constraint(equalTo: leadingAnchor)
        ]
        NSLayoutConstraint.activate(placeholderConstraints)
        
        field.defaultTextAttributes = textStyleFactory.makeAttributes()
        field.tintColor = tintColor
        addSubview(field)
        let fieldConstraints = [
            field.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor),
            field.trailingAnchor.constraint(lessThanOrEqualTo: actionButton.leadingAnchor, constant: -10),
            field.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor),
            icon != nil ?
                field.leadingAnchor.constraint(equalTo: iconHolder.trailingAnchor, constant: 12) :
                field.leadingAnchor.constraint(equalTo: leadingAnchor)
        ]
        NSLayoutConstraint.activate(fieldConstraints)
    }
    
    @objc func doOnTap() {
        field.becomeFirstResponder()
    }
    
    public func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        let text = replace(currentText: textField.text, replacementString: string, textRange: range)
        textField.text = text
        handleValueChanged()
        return false
    }
    
    private func filter(string: String) -> String {
        guard let allowedCharacters = allowedCharacters else {
            return string
        }
        let charSet = CharacterSet(charactersIn: allowedCharacters)
        if string.rangeOfCharacter(from: charSet) != nil {
            return ""
        }
        return string
    }
    
    private func replace(currentText: String?, replacementString: String, textRange: NSRange) -> String? {
        guard let currentText = currentText else {
            return nil
        }
        guard let textRange = Range(textRange, in: currentText) else {
            return currentText
        }
        var filteredString = filter(string: replacementString)
        return currentText.replacingCharacters(in: textRange, with: filteredString)
    }
    
    private func handleValueChanged() {
        shouldFireOnValueChanged = true
        updateAccesories()
    }
    
    private func updateAccesories() {
        let isValueEmpty = self.value?.isEmpty ?? true
        UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
            self.actionButton.isHidden = isValueEmpty
            self.placeholder.alpha = isValueEmpty ? 0.7 : 0
        })
    }
    
    @objc private func doOnClearTap() {
        field.text = nil
        handleValueChanged()
    }
}
