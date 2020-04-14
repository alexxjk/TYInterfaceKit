//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation

public extension Behavior {
    class PinAnimation: Behavior {
        
        public let pin: Pin
        
        public init(
            id: String? = nil,
            trigger: Behavior.Trigger = .manually,
            pin: Pin
        ) {
            self.pin = pin
            super.init(id: id, trigger: trigger)
        }
    
    }
}


