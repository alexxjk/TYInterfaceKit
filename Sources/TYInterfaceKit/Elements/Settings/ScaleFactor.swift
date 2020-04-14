//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation

public struct ScaleFactor {
    
    public let x: Float
    
    public let y: Float
    
    public var allAxises: Float? {
        return x == y ? x : nil
    }
    
    public init(x: Float, y: Float) {
        self.x = x
        self.y = y
    }
    
    public init(factor: Float) {
        self.init(x: factor, y: factor)
    }
    
    public static var one: ScaleFactor {
        return ScaleFactor(x: 1, y: 1)
    }
    
    public static var zero: ScaleFactor {
        return ScaleFactor(x: 0.01, y: 0.01)
    }
}

