//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class VStackElementMaker<TElement: VStackElementImpl>: ElementMaker<TElement> {
    
    private var spacing: Float = 0
    
    private var topPadding: Float = 0
    
    open override var configurator: ElementViewConfigurator {
        return ElementViewConfigurator(preservesSuperviewLayoutMargins: true)
    }
    
    public func spacing(_ spacing: Float) -> Self {
        self.spacing = spacing
        return self
    }
    
    public func topPadding(_ topPadding: Float) -> Self {
        self.topPadding = topPadding
        return self
    }
    
    public override init() { }
    
    public override func make() -> TElement {
        let element = super.make()
        element.spacing = spacing
        element.topPadding = topPadding
        return element
    }
}

