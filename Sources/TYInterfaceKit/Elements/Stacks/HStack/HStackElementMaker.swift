//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class HStackElementMaker<TElement: HStackElementDefault>: ElementMaker<TElement> {
    
    private var spacing: Float = 0
    
    private var leadingPadding: Float = 0
    
    private var distribution: UIStackView.Distribution?
    
    open override var configurator: ElementViewConfigurator {
        return ElementViewConfigurator(preservesSuperviewLayoutMargins: true)
    }
    
    public func spacing(_ spacing: Float) -> Self {
        self.spacing = spacing
        return self
    }
    
    public func leadingPadding(_ leadingPadding: Float) -> Self {
        self.leadingPadding = leadingPadding
        return self
    }
    
    public func distribution(_ distribution: UIStackView.Distribution) -> Self {
        self.distribution = distribution
        return self
    }
    
    public override init() { }
    
    public override func make() -> TElement {
        let element = super.make()
        element.spacing = spacing
        element.leadingPadding = leadingPadding
        if let distribution = distribution {
            element.distribution = distribution
        }
        return element
    }
}

