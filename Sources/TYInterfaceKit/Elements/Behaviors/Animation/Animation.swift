//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation

public extension Behavior {
    class Animation: Behavior {
        
        public let properties: [AnimationProperty]
        
        public let duration: TimeInterval
        
        public let isPerpetual: Bool
        
        public let isReversible: Bool
        
        public let delay: TimeInterval
        
        public let curve: Curve
        
        public init(
            id: String? = nil,
            trigger: Behavior.Trigger = .manually,
            properties: [AnimationProperty] = [],
            isPerpetual: Bool = false,
            isReversed: Bool = false,
            duration: TimeInterval,
            delay: TimeInterval = 0,
            curve: Curve = .easeOut
        ) {
            self.properties = properties
            self.duration = duration
            self.isPerpetual = isPerpetual
            self.isReversible = isReversed
            self.delay = delay
            self.curve = curve
            super.init(id: id, trigger: trigger)
        }
        
        public enum Curve {
            case easeInOut
            
            case easeIn
            
            case easeOut
            
            case linear
        }
    }
}

