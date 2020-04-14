//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ElementView: UIView, Element {
    
    private var viewAppearanceCounter = 0
    
    private var viewAppearingCounter = 0
    
    var proxy: ElementViewProxy!
    
    public var children = [Element]()
    
    var contentView: ElementView?
    
    public var opacity: Float {
        get {
            return proxy.opacity()
        }
        set {
            proxy.opacity(updateWith: newValue)
        }
    }
    
    public var background: UIColor {
        get {
            return proxy.background()
        }
        set {
            proxy.background(updateWith: newValue)
        }
    }
    
    public var borders: ElementBorder? {
        get {
            return proxy.borders()
        }
        set {
            proxy.borders(updateWith: newValue)
        }
    }
    
    public var scaleFactor: ScaleFactor {
        get {
            return proxy.scaleFactor()
        }
        set {
            proxy.scaleFactor(updateWith: newValue)
        }
    }
    
    public var pins: Set<Pin> {
        get {
            return proxy.pins
        }
        set {
            proxy.pins = newValue
        }
    }
    
    public var width: Float {
        get {
            return proxy.width()
        }
        set {
            proxy.widthToSet = newValue
        }
    }
    
    public var height: Float {
        get {
            return proxy.height()
        }
        set {
            proxy.heightToSet = newValue
        }
    }
    
    public var corners = CornerRadius(value: 0) {
        didSet {
            layer.cornerRadius = CGFloat(corners.value)
            var mask = CACornerMask()
            if corners.value > 0 {
                if corners.topRight {
                    mask.insert(.layerMaxXMinYCorner)
                }
                if corners.bottomRight {
                    mask.insert(.layerMaxXMaxYCorner)
                }
                if corners.bottomLeft {
                    mask.insert(.layerMinXMaxYCorner)
                }
                if corners.topLeft {
                    mask.insert(.layerMinXMinYCorner)
                }
            }
            layer.maskedCorners = mask
        }
    }
    
    required public init(configurator: ElementViewConfigurator) {
        super.init(frame: .zero)
        translatesAutoresizingMaskIntoConstraints = false
        layoutMargins = .zero
        directionalLayoutMargins = .zero
        backgroundColor = .clear
        preservesSuperviewLayoutMargins = configurator.preservesSuperviewLayoutMargins
        proxy = ElementViewProxy(view: self)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
       fatalError()
    }
    
    open func setup() {
        
    }
    
    public func attach(_ behavior: Behavior) {
        proxy.attach(behavior)
    }
    
    public func detach(behaviorWithId id: String) {
        proxy.detach(behaviorWithId: id)
    }
    
    public func triggerBehavior(withId id: String) {
        proxy.triggerBehavior(withId: id)
    }
    
    public func onAppearing() {
        doOnAppearing()
        proxy.doOnAppearing(appearanceCounter: viewAppearingCounter)
        viewAppearingCounter += 1
    }
    
    public func onAppeared() {
        doOnAppeared()
        proxy.doOnAppeared(appearanceCounter: viewAppearanceCounter)
        viewAppearanceCounter += 1
    }
    
    public func pin(for type: Pin.`Type`) -> Pin? {
        return pins.first { $0.type == type }
    }
    
    @discardableResult
    public func update(pin: Pin, animated: Bool = false) -> Pin {
        return proxy.update(pin: pin, animated: animated)
    }
    
    public func update(height: Float, animated: Bool) {
        return proxy.update(height: height, animated: animated)
    }
    
    public func update(opacity: Float, animated: Bool) {
        return proxy.opacity(updateWith: opacity, animated: animated)
    }
    
    public func toggleOpacity() {
        proxy.toggleOpacity()
    }
    
    open func doOnAppearing() {
        
    }
    
    open func doOnAppeared() {
        
    }
    
    open func doOnDisappearing() {
        
    }
    
    func addElement(element: ElementView) {
        children.append(element)
        if let contentView = contentView {
            contentView.addSubview(element)
        } else {
            addSubview(element)
        }
        element.setup()
        setPins(forElment: element)
        
    }
}


// MARK: - Container

extension ElementView {
    
    @discardableResult
    public func addElement<TElement: Element>(maker: () -> ElementMaker<TElement>) -> TElement {
        let maker = maker()
        let element = maker.make()
        addElement(element: element)
        maker.doOnAdded(element)
        return element
    }
    
    @discardableResult
    public func addElement<TElement: Element>(maker: () -> ControlMaker<TElement>) -> TElement {
        let maker = maker()
        let element = maker.make()
        children.append(element)
        if let contentView = contentView {
            contentView.addSubview(element)
        } else {
            addSubview(element)
        }
        setPins(forElment: element)
        element.setup()
        maker.doOnAdded(element)
        return element
    }
    
    public func addElement(_ element: ElementView) {
        addElement(element: element)
    }
    
    public func removeAllElements() {
        children.forEach {
            if let view = $0 as? UIView {
                view.removeFromSuperview()
            }
        }
        children.removeAll()
    }
    
    private func setPins<TElement: ElementView>(forElment element: TElement) {
        
        if let widthConstant = element.proxy.widthToSet {
            element.widthAnchor.constraint(equalToConstant: CGFloat(widthConstant)).isActive = true
        }
        
        if let heightConstant = element.proxy.heightToSet {
            let heightConstraint = element.heightAnchor.constraint(equalToConstant: CGFloat(heightConstant))
            heightConstraint.priority = .defaultHigh
            heightConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate(element.pins.map { proxy.constraint(for: element, and: $0) })
    }
    
    private func setPins<TElement: ElementControl>(forElment element: TElement) {
        
        if let widthConstant = element.proxy.widthToSet {
            element.widthAnchor.constraint(equalToConstant: CGFloat(widthConstant)).isActive = true
        }
        
        if let heightConstant = element.proxy.heightToSet {
            let heightConstraint = element.heightAnchor.constraint(equalToConstant: CGFloat(heightConstant))
            heightConstraint.priority = .defaultHigh
            heightConstraint.isActive = true
        }
        
        NSLayoutConstraint.activate(element.pins.map { proxy.constraint(for: element, and: $0) })
    }
    
}

public struct CornerRadius {
    
    public let value: Float
    
    public let topRight: Bool
    
    public let bottomRight: Bool
    
    public let bottomLeft: Bool
    
    public let topLeft: Bool
    
    public init(value: Float, topRight: Bool, bottomRight: Bool, bottomLeft: Bool, topLeft: Bool) {
        self.value = value
        self.topRight = topRight
        self.bottomRight = bottomRight
        self.bottomLeft = bottomLeft
        self.topLeft = topLeft
    }
    
    public init(value: Float) {
        self.init(value: value, topRight: true, bottomRight: true, bottomLeft: true, topLeft: true)
    }
    
    static func zero() -> CornerRadius {
        return CornerRadius(value: 0)
    }
}

public class ElementViewConfigurator {
    public var preservesSuperviewLayoutMargins: Bool = false
    
    public init(preservesSuperviewLayoutMargins: Bool = false) {
        self.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins
    }
}
