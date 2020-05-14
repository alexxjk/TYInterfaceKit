//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

public struct Pin: Hashable {
    
    public let toElement: Element?
    
    public let type: `Type`
    
    public let offset: Float
    
    public let respectingSafeArea: Bool
    
    public let respectingLayoutMargings: Bool
    
    public let priority: UILayoutPriority?
    
    public init(
        toElement: Element? = nil,
        type: `Type`,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true,
        priority: UILayoutPriority? = nil)
    {
        self.toElement = toElement
        self.type = type
        self.offset = offset
        self.respectingSafeArea = respectingSafeArea
        self.respectingLayoutMargings = respectingLayuMargings
        self.priority = priority
    }
    
    public enum `Type`: Hashable {
        
        case centerHorizontaly
        
        case centerVerticaly
        
        case top
        
        case trailing
        
        case bottom
        
        case leading
        
        case leadingTrailing
        
        case trailingLeading
        
        case topBottom
        
        case bottomTop
        
        case centerLeading
        
        case baseline
        
        case centerBottom
        
        case trailingFloatingLeading
    }
    
    public static func == (lhs: Pin, rhs: Pin) -> Bool {
        return lhs.type == rhs.type
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(type)
    }
}

public extension Pin {

    static func top(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .top,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func leading(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .leading,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func bottom(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true,
        priority: UILayoutPriority? = nil
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .bottom,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings,
            priority: priority
        )
    }
    
    static func trailing(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .trailing,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func trailingFloatingleading(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .trailingFloatingLeading,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func topBottom(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .topBottom,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func leadingTrailing(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .leadingTrailing,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func trailingLeading(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .trailingLeading,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func centerVerticaly(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .centerVerticaly,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func centerHorizontaly(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .centerHorizontaly,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
    
    static func baseline(
        toElement: Element? = nil,
        offset: Float = 0,
        respectingSafeArea: Bool = true,
        respectingLayuMargings: Bool = true
    ) -> Pin {
        return Pin(
            toElement: toElement,
            type: .baseline,
            offset: offset,
            respectingSafeArea: respectingSafeArea,
            respectingLayuMargings: respectingLayuMargings
        )
    }
}

