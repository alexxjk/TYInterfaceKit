//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation

public class Behavior {
    
    public let id: String
    
    public let trigger: Trigger
    
    public init(id: String?, trigger: Trigger) {
        self.id = id ?? UUID().uuidString
        self.trigger = trigger
    }
    
    public enum Trigger {
        case manually
        case onAttached
        case onAppearing(onlyOnce: Bool)
        case onAppeared(onlyOnce: Bool)
        
        var isManually: Bool {
            switch self {
            case .manually:
                return true
            default:
                return false
            }
        }
        
        var isOnAttached: Bool {
            switch self {
            case .onAttached:
                return true
            default:
                return false
            }
        }
        
        var isOnAppearing: Bool {
            switch self {
            case .onAppearing:
                return true
            default:
                return false
            }
        }
        
        var isOnAppeared: Bool {
            switch self {
            case .onAppeared:
                return true
            default:
                return false
            }
        }
        
        var isOnAppearingOnce: Bool {
            switch self {
            case .onAppearing(let onlyOnce):
                return onlyOnce
            default:
                return false
            }
        }
        
        var isOnAppearedOnce: Bool {
            switch self {
            case .onAppeared(let onlyOnce):
                return onlyOnce
            default:
                return false
            }
        }
    }
    
    public static func create(from descriptor: Descriptor, withId id: String? = nil, triggerOn trigger: Trigger = .onAttached) -> Behavior {
        switch descriptor {
        case .animation(let properties, let duration):
            return Animation(id: id, trigger: trigger, properties: properties, duration: duration)
        case .scale(let scaleFactor, let duration):
            return ScaleAnimation(id: id, trigger: trigger, scaleFactor: scaleFactor, duration: duration)
        case .opacity(let toValue, let duration):
            return OpacityAnimation(id: id, trigger: trigger, toValue: toValue, duration: duration)
        }
    }
    
    public enum Descriptor {
        
        case animation(properties: [AnimationProperty], duration: TimeInterval)
        
        case scale(scaleFactor: ScaleFactor, duration: TimeInterval)
        
        case opacity(toValue: Float, duration: TimeInterval)
    
    }
}
