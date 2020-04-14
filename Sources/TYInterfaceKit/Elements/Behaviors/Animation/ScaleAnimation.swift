//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation

public extension Behavior {
    final class ScaleAnimation: Animation {
        
        public init(
            id: String? = nil,
            trigger: Behavior.Trigger = .manually,
            scaleFactor: ScaleFactor,
            isPerpetual: Bool = false,
            isReversed: Bool = false,
            duration: TimeInterval,
            delay: TimeInterval = 0,
            curve: Curve = .easeInOut
        ) {
            
            super.init(
                id: id,
                trigger: trigger,
                properties: [.scale(to: scaleFactor)],
                isPerpetual: isPerpetual,
                isReversed: isReversed,
                duration: duration,
                delay: delay,
                curve: curve
            )
        }
        
    }
}

