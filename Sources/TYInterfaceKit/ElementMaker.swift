//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class BaseElementMaker<TElement: Element> {
    
    public var backgroundColor: UIColor?
    
    var opacity: Float = 1
    
    var scale: ScaleFactor = .one
    
    var borders: ElementBorder?
    
    var corners: CornerRadius?
    
    var behaviors = [Behavior]()
    
    var pin = Set<Pin>()
    
    var widthConstant: Float?
    
    var widthToElement: Element?
    var widthToElementMultiplier: Float?
    var widthToElementOffset: Float?
    
    var heightConstant: Float?
    
    var heightToWidthMultiplier: Float?
    
    var tintColor: UIColor?
    
    open var configurator: ElementViewConfigurator {
        return ElementViewConfigurator()
    }
    
    public init() { }
    
    public func opacity(_ alpha: Float) -> Self {
        self.opacity = alpha
        return self
    }
    
    public func scale(_ scale: ScaleFactor) -> Self {
        self.scale = scale
        return self
    }
    
    public func width(_ widthConstant: Float) -> Self {
        self.widthConstant = widthConstant
        return self
    }
    
    public func width(toElement elemnt: Element, widthToElementMultiplier: Float? = nil, widthToElementOffset: Float? = nil) -> Self {
        self.widthToElement = elemnt
        self.widthToElementMultiplier = widthToElementMultiplier
        self.widthToElementOffset = widthToElementOffset
        return self
    }
    
    public func heightToWdith(withMultiplier multiplier: Float? = 1) -> Self {
        self.heightToWidthMultiplier = multiplier
        return self
    }
    
    public func height(_ heightConstant: Float) -> Self {
        self.heightConstant = heightConstant
        return self
    }
    
    public func background(_ color: UIColor) -> Self {
        self.backgroundColor = color
        return self
    }
    
    public func borders(_ borders: ElementBorder) -> Self {
        self.borders = borders
        return self
    }
    
    public func corners(_ corners: CornerRadius) -> Self {
        self.corners = corners
        return self
    }
    
    public func tintColor(_ tintColor: UIColor?) -> Self {
        self.tintColor = tintColor
        return self
    }
    
    open func doOnAdded(_ element: TElement) {
        
    }
    
    public func pin(
        toElement element: Element? = nil,
        margins: UIEdgeInsets = .zero,
        respectingSafeArea: Bool = true,
        respectingLayoutMargings: Bool = true
    ) -> Self {
        self.pin.update(with: Pin(toElement: element, type: .top, offset: Float(margins.top), respectingSafeArea: respectingSafeArea, respectingLayuMargings: respectingLayoutMargings))
        self.pin.update(with: Pin(toElement: element, type: .trailing, offset: Float(margins.right), respectingSafeArea: respectingSafeArea, respectingLayuMargings: respectingLayoutMargings))
        self.pin.update(with: Pin(toElement: element, type: .bottom, offset: Float(margins.bottom), respectingSafeArea: respectingSafeArea, respectingLayuMargings: respectingLayoutMargings))
        self.pin.update(with: Pin(toElement: element, type: .leading, offset: Float(margins.left), respectingSafeArea: respectingSafeArea, respectingLayuMargings: respectingLayoutMargings))
        return self
    }
    
    public func center(toElement element: Element? = nil) -> Self {
        self.pin.update(with: Pin(toElement: element, type: .centerHorizontaly))
        self.pin.update(with: Pin(toElement: element, type: .centerVerticaly))
        return self
    }
    
    public func pin(at pin: Pin) -> Self {
        self.pin.update(with: pin)
        return self
    }
    
    public func behavior(_ behavior: Behavior) -> Self {
        self.behaviors.append(behavior)
        return self
    }
    
    public func on(_ trigger: Behavior.Trigger, _ descriptor: Behavior.Descriptor) -> Self {
        let behaviorToAttach = Behavior.create(from: descriptor, triggerOn: trigger)
        return behavior(behaviorToAttach)
    }
    
    open func make() -> TElement {
        
        fatalError()
    }
}

open class ElementMaker<TElement: ElementView & Element>: BaseElementMaker<TElement> {
    
    open override func make() -> TElement {
        
        let element = TElement(configurator: configurator)

        element.translatesAutoresizingMaskIntoConstraints = false
        
        element.opacity = opacity
        
        element.scaleFactor = scale
        
        if let widthConstant = widthConstant {
            element.width = widthConstant
        }
        
        element.proxy.widthToElement = widthToElement
        element.proxy.widthToElementMultiplier = widthToElementMultiplier
        element.proxy.widthToElementOffset = widthToElementOffset
        
        element.proxy.heightToWidthMultiplier = heightToWidthMultiplier
        
        if let heightConstant = heightConstant {
            element.height = heightConstant
        }
        
        element.pins = pin
        
        if let backgroundColor = backgroundColor {
            element.backgroundColor = backgroundColor
        }
        
        if let corners = corners {
            element.corners = corners
        }
        
        behaviors.forEach {
            element.attach($0)
        }
        
        return element
    }
}

open class ControlMaker<TElement: ElementControl & Control>: BaseElementMaker<TElement> {
    
    private var tap: (() -> Void)?
    
    open override func make() -> TElement {
        
        let element = TElement(configurator: configurator)

        element.translatesAutoresizingMaskIntoConstraints = false
        
        element.opacity = opacity
        
        element.scaleFactor = scale
        
        if let widthConstant = widthConstant {
            element.width = widthConstant
        }
        
        element.proxy.widthToElement = widthToElement
        element.proxy.widthToElementMultiplier = widthToElementMultiplier
        element.proxy.widthToElementOffset = widthToElementOffset
        
        if let heightConstant = heightConstant {
            element.height = heightConstant
        }
        
        element.pins = pin
        
        if let backgroundColor = backgroundColor {
            element.backgroundColor = backgroundColor
        }

        if let corners = corners {
            element.corners = corners
        }
        
        behaviors.forEach {
            element.attach($0)
        }
        
        element.doOnTap = tap
        
        return element
    }
    
    public func on(tap: @escaping () -> Void) -> Self {
        self.tap = tap
        return self
    }
}

