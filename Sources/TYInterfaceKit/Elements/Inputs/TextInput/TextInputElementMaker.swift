//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class TextInputElementMakerBase<TElement: ElementView & TextInputElement>: ElementMaker<TElement> {
    
    private var valueChanged: (() -> Void)?
   
    private var placeholderText: String?
    
    private var textStyleFactory: TextStyleBuilder = .default()
    
    public override init() { }
    
    public func placeholderText(_ placeholderText: String?) -> Self {
        self.placeholderText = placeholderText
        return self
    }
    
    public func textStyleFactory(_ textStyleFactory: TextStyleBuilder) -> Self {
        self.textStyleFactory = textStyleFactory
        return self
    }
    
    public func on(valueChanged: @escaping () -> Void) -> Self {
        self.valueChanged = valueChanged
        return self
    }
    
    public override func make() -> TElement {
        let element = super.make()
        element.placeholderText = placeholderText
        element.textStyleFactory = textStyleFactory
        element.tintColor = tintColor
        element.doOnValueChanged = valueChanged
        return element
    }
}

open class SinglelineTextInputElementMaker: TextInputElementMakerBase<TextInputElementImpl> {
    
    private var icon: UIImage?
    
    private var clearIcon: UIImage?
    
    public func icon(_ icon: UIImage?) -> Self {
        self.icon = icon
        return self
    }
    
    public func clearIcon(_ icon: UIImage?) -> Self {
        self.clearIcon = icon
        return self
    }
    
    public override func make() -> TextInputElementImpl {
        let element = super.make()
        element.icon = icon
        element.clearButtonIcon = clearIcon
        return element
    }
}

open class MultilineTextInputElementMaker: TextInputElementMakerBase<MultilineTextInputElementImpl> {
}

