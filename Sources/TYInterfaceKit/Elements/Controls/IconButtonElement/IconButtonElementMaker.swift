//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class IconButtonElementMaker<TIconButtonElement: IconButtonElementImpl>: ControlMaker<TIconButtonElement> {
    
    private var icon: UIImage?
    
    public override init() { }
    
    public func icon(_ icon: UIImage?) -> Self {
        self.icon = icon
        return self
    }
    
    public override func make() -> TIconButtonElement {
        let elemnt = super.make()
        if let icon = icon {
            elemnt.icon = icon
        }
        // Image must be set before tintColor
        elemnt.tintColor = tintColor
        return elemnt
    }
}

