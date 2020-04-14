//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation

public extension Behavior {
    class AppearanceAnimation: Behavior {
        
        public let type: Type
        
        public init(id: String? = nil, type: Type, onlyOnce: Bool = false, onAppearing: Bool = false) {
            self.type = type
            super.init(id: id, trigger: !onAppearing ? .onAppeared(onlyOnce: onlyOnce) : .onAppearing(onlyOnce: onlyOnce))
        }
            
        public enum `Type` {
            case slideFromBottom
            case opacity
        }
    }
}

