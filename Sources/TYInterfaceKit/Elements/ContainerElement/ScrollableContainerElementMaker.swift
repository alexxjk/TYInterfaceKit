//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ScrollableContainerElementMaker<TContainerElement: ScrollableContainerElementImpl>: ElementMaker<TContainerElement> {
    
    private var isRounded: Bool = false
    
    private var preservesSuperviewLayoutMargins: Bool = false
    
    private var insets: UIEdgeInsets = .zero
    
    private var offsetChanged: ((_ verticalOffset: Float) -> Void)?
    
    open override var configurator: ElementViewConfigurator {
        return ElementViewConfigurator(preservesSuperviewLayoutMargins: true)
    }
    
    public func rounded() -> Self {
        self.isRounded = true
        return self
    }
    
    public func insets(_ insets: UIEdgeInsets) -> Self {
        self.insets = insets
        return self
    }
    
    public func on(offsetChanged: @escaping ((_ verticalOffset: Float) -> Void)) -> Self {
        self.offsetChanged = offsetChanged
        return self
    }
    
    public init(preservesSuperviewLayoutMargins: Bool) {
        self.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins
        super.init()
    }
    
    public override func make() -> TContainerElement {
        let element = super.make()
        element.insets = insets
        element.doOnScroll = offsetChanged
        if let widthConstant = widthConstant, isRounded {
            element.corners = CornerRadius(value: widthConstant / 2.0)
        } else {
            element.corners = corners ?? .zero()
        }
        return element
    }
    

}

