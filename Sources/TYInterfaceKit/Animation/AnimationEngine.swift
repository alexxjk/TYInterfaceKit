//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

public class AnimationEngine {
    
    public static func replace(
        _ oldElement: Element,
        with newElement: Element,
        in duration: TimeInterval,
        withContainer container: UIView
    ) {
        UIView.animate(withDuration: duration, delay: 0, options: .transitionCrossDissolve, animations: {
            oldElement.opacity = 0
            newElement.opacity = 1
        })
    }
    
    public static func hide(element: Element, in duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            element.opacity = 0
        })
    }
    
    public static func show(element: Element, in duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            element.opacity = 1
        })
    }
    
    public static func dim(element: Element, in duration: TimeInterval) {
        UIView.animate(withDuration: duration, delay: 0, options: [.curveEaseIn], animations: {
            element.opacity = 0.3
        })
    }
}

