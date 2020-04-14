//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ContainerElementMaker<TContainerElement: ContainerElementImpl>: ElementMaker<TContainerElement> {
    
    private var isRounded: Bool = false
    
    private var paddings: NSDirectionalEdgeInsets?
    
    private var clip: Bool?
    
    open override var configurator: ElementViewConfigurator {
        return ElementViewConfigurator(preservesSuperviewLayoutMargins: true)
    }
    
    public func clip(_ clip: Bool) -> Self {
        self.clip = clip
        return self
    }
    
    public func rounded() -> Self {
        self.isRounded = true
        return self
    }
    
    public func padding(_ paddings: NSDirectionalEdgeInsets?) -> Self {
        self.paddings = paddings
        return self
    }
    
    public override init() { }

    public override func make() -> TContainerElement {
        let elemnt = super.make()
        if let widthConstant = widthConstant, isRounded {
            elemnt.corners = CornerRadius(value: widthConstant / 2.0)
        } else {
            elemnt.corners = corners ?? .zero()
        }
        if let paddings = paddings {
            elemnt.paddings = paddings
        }
        if let clip = clip {
            elemnt.clip = clip
        }
        return elemnt
    }
}

