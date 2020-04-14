//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol Element: class {
    
    var opacity: Float { get set }
    
    var background: UIColor { get set }
    
    var borders: ElementBorder? { get set }
    
    var scaleFactor: ScaleFactor { get set }
    
    var pins: Set<Pin> { get set }
    
    var height: Float { get }
    
    var width: Float { get }
    
    func attach(_ behavior: Behavior)
    
    func detach(behaviorWithId id: String)
    
    func triggerBehavior(withId id: String)
    
    func onAppeared()
    
    func onAppearing()
    
    func pin(for type: Pin.`Type`) -> Pin?
    
    @discardableResult
    func update(pin: Pin, animated: Bool) -> Pin
    
    func update(height: Float, animated: Bool)
    
    func update(opacity: Float, animated: Bool)
    
    func toggleOpacity()
    
    init(configurator: ElementViewConfigurator)
}

public struct ElementBorder {
    
    public let color: UIColor
    
    public let width: Float
    
    public init(color: UIColor, width: Float) {
        self.color = color
        self.width = width
    }
}


