//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ListElementMaker<TItem, TItemElement, TLoadingItem, TListElement: ListElementImpl<TItem, TItemElement, TLoadingItem>>: ElementMaker<TListElement> {
    
    private var insets: UIEdgeInsets?
    
    private var spacing: Float?
    
    private var offsetChanged: ((_ offset: Float) -> Void)?
    
    private var itemSelected: ((_ item: TItem) -> Void)?
    
    private var scrolledToEnd: (() -> Void)?
    
    private let axis: ListElementAxis
    
    private let alwaysBounce: Bool
    
    private let autoSize: Bool
    
    private var horizontalWidthCoef: CGFloat?
    
    public override var configurator: ElementViewConfigurator {
        return ListElementViewConfigurator(axis: axis, alwaysBounce: alwaysBounce, preservesSuperviewLayoutMargins: true, autoSize: autoSize)
    }
    
    public init(axis: ListElementAxis, autoSize: Bool = false, alwaysBounce: Bool = false) {
        self.axis = axis
        self.autoSize = autoSize
        self.alwaysBounce = alwaysBounce
        super.init()
    }
    
    open override func make() -> TListElement {
        let elemnt = super.make()
        if let insets = insets {
            elemnt.insets = insets
        }
        if let spacing = spacing {
            elemnt.spacing = spacing
        }
        elemnt.doOnScroll = offsetChanged
        elemnt.doOnItemSelected = itemSelected
        elemnt.doOnScrolledToEnd = scrolledToEnd
        elemnt.horizontalWidthCoef = horizontalWidthCoef ?? 0.67
        return elemnt
    }
    
    public func insets(_ insets: UIEdgeInsets) -> Self {
        self.insets = insets
        return self
    }
    
    public func spacing(_ spacing: Float) -> Self {
        self.spacing = spacing
        return self
    }
    
    public func horizontalWidthCoef(_ horizontalWidthCoef: CGFloat) -> Self {
        self.horizontalWidthCoef = horizontalWidthCoef
        return self
    }
    
    public func on(offsetChanged: @escaping ((_ offset: Float) -> Void)) -> Self {
        self.offsetChanged = offsetChanged
        return self
    }
    
    public func on(itemSelected: @escaping ((_ item: TItem) -> Void)) -> Self {
        self.itemSelected = itemSelected
        return self
    }
    
    public func on(scrolledToEnd: @escaping (() -> Void)) -> Self {
        self.scrolledToEnd = scrolledToEnd
        return self
    }
}

