//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ImageElementMaker<TImageElement: ImageElementImpl>: ElementMaker<TImageElement> {
    
    private var image: UIImage?
    
    private var contentMode: UIView.ContentMode?
    
    public override init() { }
    
    public func image(_ image: UIImage?) -> Self {
        self.image = image
        return self
    }
    
    public func contentMode(_ contentMode: UIView.ContentMode) -> Self {
        self.contentMode = contentMode
        return self
    }
    
    public override func make() -> TImageElement {
        let elemnt = super.make()
        if let image = image {
            elemnt.image = image
        }
        if let contentMode = contentMode {
            elemnt.contentMode = contentMode
        }
        // Image must be set before tintColor
        elemnt.tintColor = tintColor
        return elemnt
    }
}


