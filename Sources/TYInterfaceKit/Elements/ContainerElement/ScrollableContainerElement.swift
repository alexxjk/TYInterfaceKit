//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol ScrollableContainerElement: ContainerElement {
    
    var doOnScroll: ((_ verticalOffset: Float) -> Void)? { get }
    
    var verticalOffset: Float { get }
    
    var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior { get set }
    
}

