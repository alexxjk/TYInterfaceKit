//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 5/2/20.
//

import UIKit

final class SliderElementMaker<TSextantElement: SliderElementDefault>: ElementMaker<TSextantElement> {
    
    private var valueChanged: ((_ value: Float) -> Void)?
    
    private var valueChanging: ((_ value: Float) -> Void)?
    
    private var interfactionStarted: (() -> Void)?
    
    private var interactionEnded: (() -> Void)?
    
    private var isCompact: Bool = false
    
    private var wrappedInContainer: Bool = true
    
    private var thumbImage: UIImage?
    
    private var progressColor: UIColor?
    
    override init() {
        super.init()
    }
    
    override func make() -> TSextantElement {
        let element = super.make()
        if wrappedInContainer {
            if isCompact {
                element.height = 68
            } else {
                element.height = 88
            }
        } else {
            element.height = 32
        }
        element.background = wrappedInContainer ? (backgroundColor ?? .clear) : .clear
        element.wrappedInContainer = wrappedInContainer
        element.doOnValueChanged = valueChanged
        element.doOnValueChanging = valueChanging
        element.doOnInteractionStarted = interfactionStarted
        element.doOnInteractionEnded = interactionEnded
        element.thumbImage = thumbImage
        element.progressColor = progressColor
        return element
    }
    
    func wrappedInContainer(_ wrappedInContainer: Bool) -> Self {
        self.wrappedInContainer = wrappedInContainer
        return self
    }
    
    func isCompact(_ isCompact: Bool) -> Self {
        self.isCompact = isCompact
        return self
    }
    
    func thumbImage(_ thumbImage: UIImage?) -> Self {
        self.thumbImage = thumbImage
        return self
    }
    
    func progressColor(_ progressColor: UIColor?) -> Self {
        self.progressColor = progressColor
        return self
    }
    
    func on(valueChanged: @escaping ((_ value: Float) -> Void)) -> Self {
        self.valueChanged = valueChanged
        return self
    }
    
    func on(valueChanging: @escaping ((_ value: Float) -> Void)) -> Self {
        self.valueChanging = valueChanging
        return self
    }
    
    func on(interactionStarted: @escaping (() -> Void)) -> Self {
        self.interfactionStarted = interactionStarted
        return self
    }
    
    func on(interactionEnded: @escaping (() -> Void)) -> Self {
        self.interactionEnded = interactionEnded
        return self
    }
}
