//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 5/2/20.
//

import UIKit

public final class SliderElementMaker<TSextantElement: SliderElementDefault>: ElementMaker<TSextantElement> {
    
    private var valueChanged: ((_ value: Float) -> Void)?
    
    private var valueChanging: ((_ value: Float) -> Void)?
    
    private var interfactionStarted: (() -> Void)?
    
    private var interactionEnded: (() -> Void)?
    
    private var isCompact: Bool = false
    
    private var wrappedInContainer: Bool = true
    
    private var thumbImage: UIImage?
    
    private var progressColor: UIColor?
    
    public override init() {
        super.init()
    }
    
    override public func make() -> TSextantElement {
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
    
    public func wrappedInContainer(_ wrappedInContainer: Bool) -> Self {
        self.wrappedInContainer = wrappedInContainer
        return self
    }
    
    public func isCompact(_ isCompact: Bool) -> Self {
        self.isCompact = isCompact
        return self
    }
    
    public func thumbImage(_ thumbImage: UIImage?) -> Self {
        self.thumbImage = thumbImage
        return self
    }
    
    public func progressColor(_ progressColor: UIColor?) -> Self {
        self.progressColor = progressColor
        return self
    }
    
    public func on(valueChanged: @escaping ((_ value: Float) -> Void)) -> Self {
        self.valueChanged = valueChanged
        return self
    }
    
    public func on(valueChanging: @escaping ((_ value: Float) -> Void)) -> Self {
        self.valueChanging = valueChanging
        return self
    }
    
    public func on(interactionStarted: @escaping (() -> Void)) -> Self {
        self.interfactionStarted = interactionStarted
        return self
    }
    
    public func on(interactionEnded: @escaping (() -> Void)) -> Self {
        self.interactionEnded = interactionEnded
        return self
    }
}
