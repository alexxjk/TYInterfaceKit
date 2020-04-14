//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

public class TimerDrivenAnimationEngine: AnimationEngine {
    
    private var counter: Int = 0
    
    private var timer: Timer?
    
    private let step: TimeInterval
    
    private let total: TimeInterval
    
    private let animationCallback: (_ progress: Double) -> Void
    
    public init(step: TimeInterval, total: TimeInterval,  animationCallback: @escaping (_ progress: Double) -> Void) {
        self.step = step
        self.total = total
        self.animationCallback = animationCallback
    }
    
    public func run() {
        timer = Timer.scheduledTimer(withTimeInterval: step, repeats: true, block: { [weak self] timer in
            guard let self = self else {
                return
            }
            let progress = Double(self.counter) * self.step
            self.animationCallback(min(1, max(0, Double(self.counter) * self.step / self.total)))
            if progress >= self.total {
                self.timer?.invalidate()
            }
            self.counter += 1
        })
        timer?.fire()
    }
}

