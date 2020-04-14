//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ElementControl: UIControl, Control {
    
    private var viewAppearanceCounter = 0
    
    private var viewAppearingCounter = 0
    
    var proxy: ElementViewProxy!
    
    public var pins: Set<Pin> {
        get {
            return proxy.pins
        }
        set {
            proxy.pins = newValue
        }
    }
    
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
            return Float(bounds.width)
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
    
    open override var isEnabled: Bool {
        didSet {
            toggleIsEnabled()
        }
    }
    
    public var doOnTap: (() -> Void)?
    
    override public var isHighlighted: Bool {
        didSet {
            toggleIsHighlighted()
        }
    }
    
    required public init(configurator: ElementViewConfigurator) {
        super.init(frame: .zero)
        proxy = ElementViewProxy(view: self)
        translatesAutoresizingMaskIntoConstraints = false
        //layoutMargins = .zero
        directionalLayoutMargins = .zero
        backgroundColor = .clear
        preservesSuperviewLayoutMargins = configurator.preservesSuperviewLayoutMargins
        addTarget(self, action: #selector(doOnTapHandler), for: .touchUpInside)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
       fatalError()
    }
    
    open func setup() {
        
    }
    
    open func doOnAppearing() {
        
    }
    
    open func doOnAppeared() {
        
    }
    
    open func doOnDisappearing() {
        
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
    
    public func toggleOpacity() {
        proxy.toggleOpacity()
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
    
    func toggleIsHighlighted() {
        alpha = isHighlighted ? 0.5 : 1.0
    }
    
    func toggleIsEnabled() {
        alpha = !isEnabled ? 0.5 : 1.0
    }
    
    override open func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let minSize: CGFloat = 44
        if bounds.width >= minSize && bounds.height >= minSize {
            return super.point(inside: point, with: event)
        }
        let verticalInsets = (minSize - bounds.height) / 2.0
        let horizontalInsets = (minSize - bounds.width) / 2.0

        let largerArea = CGRect(
            x: bounds.origin.x - horizontalInsets,
            y: bounds.origin.y - verticalInsets,
            width: bounds.width + 2.0 * horizontalInsets,
            height: bounds.height + 2.0 * verticalInsets
        )

        return largerArea.contains(point)
    }
    
    @objc private func doOnTapHandler() {
        doOnTap?()
    }
}

