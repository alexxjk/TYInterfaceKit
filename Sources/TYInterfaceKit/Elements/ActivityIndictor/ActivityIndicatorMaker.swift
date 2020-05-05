//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 5/5/20.
//

import UIKit

final public class ActivityIndicatorMaker: ElementMaker<ActivityIndicatorElement> {
    
    private var color: UIColor?
    
    public func color(_ color: UIColor?) -> Self {
        self.color = color
        return self
    }
    
    override public init() {
        super.init()
    }
    
    override public func make() -> ActivityIndicatorElement {
        let element = super.make()
        return element
    }
}


