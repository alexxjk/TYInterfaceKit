//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public class TextElementMakerBase<TContainerElement: ElementView & TextElement>: ElementMaker<TContainerElement> {
    
    private var text: String?
    
    private var numberOfLines: Int?
    
    private var textStyleFactory: TextStyleBuilder?
    
    private var minimumScaleFactor: Float = 0
    
    public override init() { }
    
    public func text(_ text: String?) -> Self {
        self.text = text
        return self
    }
    
    public func numberOnLines(_ numberOfLines: Int) -> Self {
        self.numberOfLines = numberOfLines
        return self
    }
    
    public func textStyleFactory(_ textStyleFactory: TextStyleBuilder) -> Self {
        self.textStyleFactory = textStyleFactory
        return self
    }
    
    public func minimumScaleFactor(_ minimumScaleFactor: Float) -> Self {
        self.minimumScaleFactor = minimumScaleFactor
        return self
    }
    
    public override func make() -> TContainerElement {
        let elemnt = super.make()
        elemnt.text = text
        elemnt.numberOfLines = numberOfLines
        elemnt.minimumScaleFactor = minimumScaleFactor
        elemnt.textStyleFactory = textStyleFactory
        return elemnt
    }
}

final public class TextElementMaker: TextElementMakerBase<TextElementImpl> { }

