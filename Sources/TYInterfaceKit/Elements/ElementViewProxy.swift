//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

final class ElementViewProxy {
    
    private unowned let view: UIView
    
    private var opacityOldValue: Float = 1
    
    var behaviors = [String: Behavior]()
    
    var animators = [String: UIViewPropertyAnimator]()
    
    var pins = Set<Pin>()
    
    var widthToSet: Float?
    
    var widthToElement: Element?
    
    var heightToSet: Float?
    
    init(view: UIView) {
        self.view = view
    }
    
    func width() -> Float {
        return Float(view.bounds.width)
    }
    
    func height() -> Float {
        return Float(view.bounds.height)
    }
    
    func opacity() -> Float {
        return Float(view.alpha)
    }
    
    public func toggleOpacity() {
        if opacity() > 0 {
            opacity(updateWith: 0)
        } else {
            opacity(updateWith: opacityOldValue)
        }
    }
    
    func opacity(updateWith newValue: Float, animated: Bool = false) {
        if animated {
            let opacityAnimation = Behavior.OpacityAnimation(toValue: newValue, duration: 0.1, curve: .linear)
            trigger(opacityAnimation)
        } else {
            opacityOldValue = newValue
            view.alpha = CGFloat(newValue)
        }
    }
    
    func background() -> UIColor {
        return view.backgroundColor ?? .clear
    }
    
    func background(updateWith newValue: UIColor) {
        view.backgroundColor = newValue
    }
    
    func borders() -> ElementBorder? {
        guard let color = view.layer.borderColor, view.layer.borderWidth > 0 else {
            return nil
        }
        return ElementBorder(color: UIColor(cgColor: color), width: Float(view.layer.borderWidth))
    }
    
    func borders(updateWith newValue: ElementBorder?) {
        guard let newValue = newValue else {
            view.layer.borderColor = nil
            view.layer.borderWidth = 0
            return
        }
        view.layer.borderColor = newValue.color.cgColor
        view.layer.borderWidth = CGFloat(newValue.width)
    }
    
    func scaleFactor() -> ScaleFactor {
        return ScaleFactor(x: Float(view.transform.a), y: Float(view.transform.d))
    }
    
    func scaleFactor(updateWith newValue: ScaleFactor) {
        let scale = newValue
        view.transform = CGAffineTransform.identity.scaledBy(x: CGFloat(scale.x), y: CGFloat(scale.y))
    }
    
    func attach(_ behavior: Behavior) {
        behaviors[behavior.id] = behavior
        if behavior.trigger.isOnAttached {
            triggerBehavior(withId: behavior.id)
        }
    }
    
    public func detach(behaviorWithId id: String) {
        
        defer {
            if let behavior = behaviors[id] {
                remove(behavior)
            }
        }
        
        if let animator = animators[id] {
            animator.stopAnimation(true)
            animator.finishAnimation(at: .current)
        }
    }
    
    @discardableResult
    func update(pin: Pin, animated: Bool = false) -> Pin {
       
        if pins.insert(pin).inserted {
            constraint(for: view, and: pin).isActive = true
        } else {
            pins.update(with: pin)
        }

        pins.forEach { [weak self] pin in
            guard let self = self else {
                return
            }
            if let superview = view.superview,
                let constraintForPin = superview.constraints.first(where: { constraint -> Bool in
                    guard (constraint.firstItem as? UIView) == (view) else {
                    return false
                }
                switch (constraint.firstAttribute, constraint.secondAttribute, pin.type) {
                case (.top, .top, .top):
                    return true
                case (.trailing, .trailing, .trailing):
                    return true
                case (.bottom, .bottom, .bottom):
                    return true
                case (.leading, .leading, .leading):
                    return true
                case (.centerX, .centerX, .centerHorizontaly):
                    return true
                case (.centerY, .centerY, .centerVerticaly):
                    return true
                case (.centerX, .leading, .centerLeading):
                    return true
                default:
                    return false
                }
            }) {
                constraintForPin.constant = invertOffset(for: pin, and: view)
            }
            if animated {
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.view.superview?.layoutIfNeeded()
                }, completion: nil)
            } else {
                self.view.superview?.layoutIfNeeded()
            }
        }
        
        return pin
    }
    
    func update(height: Float, animated: Bool) {
        if let heightConstraint = view.constraints.first(where: { constraint -> Bool in
            guard (constraint.firstItem as? UIView) == (view) else {
               return false
            }
            return constraint.firstAttribute == .height
        }) {
            heightConstraint.constant = CGFloat(height)
            if animated {
                UIView.animate(withDuration: 0.5, delay: 0.1, options: [], animations: { [weak self] in
                    guard let self = self else {
                        return
                    }
                    self.view.layoutIfNeeded()
                }, completion: nil)
            } else {
                self.view.layoutIfNeeded()
            }
        }
        
    }
    
    func triggerBehavior(withId id: String) {
        guard let behavior = behaviors[id] else { return }
        switch behavior {
        case let animation as Behavior.Animation:
            trigger(animation)
        case let animation as Behavior.PinAnimation:
            update(pin: animation.pin, animated: true)
        case let animation as Behavior.AppearanceAnimation:
            trigger(animation)
        default:
            fatalError("Unsupported behavior")
        }
    }
    
    func doOnAppearing(appearanceCounter: Int) {
        let appearnceBehaviors = behaviors.filter { ($0.value.trigger.isOnAppearing && !$0.value.trigger.isOnAppearingOnce) || (appearanceCounter < 1 && $0.value.trigger.isOnAppearingOnce) }
        appearnceBehaviors.forEach { triggerBehavior(withId: $0.value.id) }
    }
    
    func doOnAppeared(appearanceCounter: Int) {
        let appearnceBehaviors = behaviors.filter { ($0.value.trigger.isOnAppeared && !$0.value.trigger.isOnAppearedOnce) || (appearanceCounter < 1 && $0.value.trigger.isOnAppearedOnce) }
        appearnceBehaviors.forEach { triggerBehavior(withId: $0.value.id) }
    }
    
    private func remove(_ behavior: Behavior) {
        behaviors[behavior.id] = nil
        animators[behavior.id] = nil
    }
    
    private func trigger(_ animation: Behavior.AppearanceAnimation) {
        switch animation.type {
        case .slideFromBottom:
            update(pin: .init(type: .bottom, offset: -Float(view.bounds.size.height)))
            update(pin: .init(type: .bottom), animated: true)
        case .opacity:
            opacity(updateWith: 0, animated: false)
            trigger(Behavior.Animation(id: nil, trigger: .manually, properties: [.opacity(to: 1)], isPerpetual: false, isReversed: false, duration: 0.3, delay: 0, curve: .easeIn))
        }
    }
    
    private func trigger(_ animation: Behavior.Animation) {
        let curve = { () -> UIView.AnimationCurve in
            switch animation.curve {
            case .linear:
                return .linear
            case .easeOut:
                return .easeOut
            case .easeIn:
                return .easeIn
            case .easeInOut:
                return .easeInOut
            }
        }()
        let animator = UIViewPropertyAnimator(duration: animation.duration, curve: curve) { [weak self] in
            guard let self = self else {
                return
            }
            UIView.setAnimationRepeatCount(animation.isPerpetual ? Float.greatestFiniteMagnitude : 0)
            UIView.setAnimationRepeatAutoreverses(animation.isReversible)
            animation.properties.forEach({ property in
                switch property {
                case .opacity(let toValue):
                    self.opacity(updateWith: Float(toValue))
                case .scale(let toValue):
                    self.scaleFactor(updateWith: ScaleFactor(x: toValue.x, y: toValue.y))
                case .background(let toValue):
                    self.background(updateWith: toValue)
                }
            })
        }
        animator.addCompletion { [weak self] _ in
            self?.remove(animation)
        }
        animators[animation.id] = animator
        animator.startAnimation(afterDelay: animation.delay)
    }
    
    func constraint(for element: UIView, and pin: Pin) -> NSLayoutConstraint {
        let anchor = anchorElement(for: pin, and: element)
        let anchorElement = anchor.anchrElement
        let layoutGuideForElement = layoutGuide(for: pin, and: anchorElement)
        let constraint = { () -> NSLayoutConstraint in
            switch pin.type {
            case .centerVerticaly:
                return element.centerYAnchor.constraint(equalTo: anchorElement.centerYAnchor, constant: CGFloat(pin.offset))
            case .centerHorizontaly:
                return element.centerXAnchor.constraint(equalTo: anchorElement.centerXAnchor)
            case .leading:
                return element.leadingAnchor.constraint(
                    equalTo: layoutGuideForElement?.leadingAnchor ?? anchorElement.leadingAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .trailing:
                return element.trailingAnchor.constraint(
                    equalTo: layoutGuideForElement?.trailingAnchor ?? anchorElement.trailingAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .bottom:
                return element.bottomAnchor.constraint(
                    equalTo: layoutGuideForElement?.bottomAnchor ?? anchorElement.bottomAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .top:
                return element.topAnchor.constraint(
                    equalTo: layoutGuideForElement?.topAnchor ?? anchorElement.topAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .leadingTrailing:
                return element.leadingAnchor.constraint(
                    equalTo: anchor.anchrElement.trailingAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .trailingLeading:
                return element.trailingAnchor.constraint(
                    equalTo: anchor.anchrElement.leadingAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .topBottom:
                return element.topAnchor.constraint(
                    equalTo: anchor.anchrElement.bottomAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .bottomTop:
                return element.bottomAnchor.constraint(
                    equalTo: anchor.anchrElement.topAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .centerLeading:
                return element.centerXAnchor.constraint(
                    equalTo: anchor.anchrElement.leadingAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .baseline:
                return element.firstBaselineAnchor.constraint(
                    equalTo: anchor.anchrElement.firstBaselineAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            case .centerBottom:
                return element.centerYAnchor.constraint(
                    equalTo: anchor.anchrElement.bottomAnchor,
                    constant: invertOffset(for: pin, and: element)
                )
            }
        }()
        if let priority = pin.priority {
            constraint.priority = priority
        }
        return constraint
    }
    
    private func layoutGuide(for pin: Pin, and anchorElement: UIView) -> UILayoutGuide? {
        if !pin.respectingSafeArea && !pin.respectingLayoutMargings {
            return nil
        } else if pin.respectingLayoutMargings {
            return anchorElement.layoutMarginsGuide
        } else {
            return anchorElement.safeAreaLayoutGuide
        }
    }
    
    private func anchorElement(
        for pin: Pin,
        and element: UIView
    ) -> (anchrElement: UIView, pinnedToSuperview: Bool) {
        let anchorElement = (pin.toElement as? UIView) ?? element.superview!
        let pinnedToSuperview = anchorElement == element.superview
        return (anchorElement, pinnedToSuperview)
    }
    
    private func invertOffset(for pin: Pin, and element: UIView) -> CGFloat {
        
        let anchor = anchorElement(for: pin, and: element)
        switch pin.type {
        case .trailing, .bottom:
            return anchor.pinnedToSuperview ? -CGFloat(pin.offset) : CGFloat(pin.offset)
        case .trailingLeading:
            return -CGFloat(pin.offset)
        default:
            return CGFloat(pin.offset)
        }
    }
    
}

