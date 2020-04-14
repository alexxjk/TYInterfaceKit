//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol ContainerElement: Element {
    
    var corners: CornerRadius { get set }
    
    var clip: Bool { get set }
    
    var children: [Element] { get set }
    
    @discardableResult
    func addElement<TElement: Element>(maker: () -> ElementMaker<TElement>) -> TElement
    
    @discardableResult
    func addElement<TElement: Element>(maker: () -> ControlMaker<TElement>) -> TElement
    
    func addElement(_ element: ElementView)
    
    func removeAllChildren()
}


