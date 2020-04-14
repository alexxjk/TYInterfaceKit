//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

public extension Behavior {
    final class OpacityAnimation: Animation {
        
        public init(
            id: String? = nil,
            trigger: Behavior.Trigger = .manually,
            toValue: Float,
            isPerpetual: Bool = false,
            isReversed: Bool = false,
            duration: TimeInterval,
            delay: TimeInterval = 0,
            curve: Curve = .easeInOut
        ) {
            
            super.init(
                id: id,
                trigger: trigger,
                properties: [.opacity(to: CGFloat(toValue))],
                isPerpetual: isPerpetual,
                isReversed: isReversed,
                duration: duration,
                delay: delay,
                curve: curve
            )
        }
        
    }
}

