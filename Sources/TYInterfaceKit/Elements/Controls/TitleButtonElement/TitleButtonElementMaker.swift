//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class TitleButtonElementMaker<TElement: TitleButtonElementImpl>: ControlMaker<TElement> {
    
    private var title: String = "Button"
    
    private var textStyleFactory: TextStyleBuilder?
    
    public override init() { }
    
    public func title(_ title: String) -> Self {
        self.title = title
        return self
    }
    
    public func textStyleFactory(_ textStyleFactory: TextStyleBuilder) -> Self {
        self.textStyleFactory = textStyleFactory
        return self
    }
    
    public override func make() -> TElement {
        let elemnt = super.make()
        elemnt.title = title
        elemnt.textStyleFactory = textStyleFactory
        return elemnt
    }
}
