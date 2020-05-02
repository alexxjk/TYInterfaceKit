//
//  File.swift
//
//
//  Created by Alexander Martirosov on 5/2/20.
//

import UIKit

public protocol SliderElement: Element {
    
    var props: ScoreTrackerElementProps? { get set }
    
    var doOnValueChanged: ((_ value: Float) -> Void)? { get }
    
    var doOnValueChanging: ((_ value: Float) -> Void)? { get }
    
    var doOnInteractionStarted: (() -> Void)? { get }

}

public class SliderElementDefault: ElementView, SliderElement {
    
    private var backgroundColorOnAppearing: UIColor?
    
    private var isInInteractionState = false
    
    private var totalProgress: ProgressElement!
    
    private var currentProgress: ProgressElement!
    
    private let progressBarPadding: Float = 12
    
    private var thumb: Thumb!
    private var thumpLeft: Pin!
    
    var thumbImage: UIImage?
    
    var progressColor: UIColor?
    
    var wrappedInContainer: Bool = true
    
    public var doOnValueChanged: ((_ value: Float) -> Void)?
    
    public var doOnValueChanging: ((_ value: Float) -> Void)?
    
    public var doOnInteractionStarted: (() -> Void)?
    
    var doOnInteractionEnded: (() -> Void)?
    
    public var props: ScoreTrackerElementProps? {
        didSet {
            guard props != oldValue else {
                return
            }
            updateThumb()
        }
    }
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        preservesSuperviewLayoutMargins = true
        corners = CornerRadius(value: 4, topRight: true, bottomRight: false, bottomLeft: false, topLeft: true)
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func setup() {
        super.setup()
        setupElements()
    }
    
    override public func doOnAppeared() {
        super.doOnAppeared()
        updateThumb()
        thumpLeft = thumb.pin(for: .centerLeading)
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        updateThumb()
    }
    
    private func updateThumb(){
        guard let props = props else {
            return
        }
        let newOffset = offset(fromValue: props.score)
        totalProgress.update(pin: .leading())
        totalProgress.update(pin: .trailing())
        thumb.update(pin: Pin(toElement: totalProgress, type: .centerLeading, offset: newOffset))
    }
    
    private func offset(fromValue value: Float) -> Float {
        let offset = (totalProgress.width - 2 * progressBarPadding) * value + progressBarPadding
        return offset
    }
    
    private func setupElements() {
        totalProgress = addElement {
            ProgressElement.Maker()
                .pin(at: .top(offset: wrappedInContainer ? 30 : Thumb.radius - ProgressElement.height / 2.0))
        }
        
        currentProgress = addElement {
            ProgressElement.Maker()
                .progressColor(progressColor)
                .filled(true)
                .pin(at: .leading(toElement: totalProgress))
                .pin(at: Pin(toElement: totalProgress, type: .centerVerticaly))
        }
        
        thumb = addElement {
            Thumb.Maker()
                .background(progressColor ?? .clear)
                .image(thumbImage)
                .pin(at: Pin(toElement: totalProgress, type: .centerVerticaly))
        }
        thumpLeft = thumb.update(pin: Pin(
            toElement: totalProgress,
            type: .centerLeading,
            offset: offset(fromValue: props?.score ?? 0)
        ))
        thumb.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handleThumbPan(_:))))
        
        currentProgress.update(pin: Pin(toElement: thumb, type: .trailing))
    }
    
    @objc private func handleThumbPan(_ gestureRecognizer : UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self)
        switch gestureRecognizer.state {
        case .began:
            thumpLeft = thumb.pin(for: .centerLeading)
            isInInteractionState = true
            doOnInteractionStarted?()
        case .changed:
            let offset = max(
                progressBarPadding,
                min(thumpLeft.offset + Float(translation.x), totalProgress.width - progressBarPadding)
            )
            let value = (offset - progressBarPadding) / (totalProgress.width - 2 * progressBarPadding)
            props = ScoreTrackerElementProps(score: value)
            doOnValueChanging?(value)
        case .ended:
            isInInteractionState = false
            
            let value =
                (currentProgress.width - Thumb.radius - progressBarPadding) /
                (totalProgress.width - 2 * progressBarPadding)
            
            doOnValueChanged?(value)
            thumpLeft = thumb.pin(for: .centerLeading)
            doOnInteractionEnded?()
        case .cancelled:
            isInInteractionState = false
            thumpLeft = thumb.pin(for: .centerLeading)
            doOnInteractionEnded?()
        default:
            break
        }
    }
    
    class ProgressElement: ElementView {
        
        static var height: Float = 6
        
        required init(configurator: ElementViewConfigurator) {
            super.init(configurator: configurator)
            corners = CornerRadius(value: 3)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        class Maker: ElementMaker<ProgressElement> {
            
            private var filled: Bool = false
            
            private var progressColor: UIColor?
            
            func filled(_ filled: Bool) -> Self {
                self.filled = filled
                return self
            }
            
            func progressColor(_ progressColor: UIColor?) -> Self {
                self.progressColor = progressColor
                return self
            }
            
            override func make() -> SliderElementDefault.ProgressElement {
                let element = super.make()
                element.backgroundColor = filled ? (progressColor ?? .clear) : UIColor(hex: 0xF7DAE8)
                return element
            }
            
            override init() {
                super.init()
                _ = height(ProgressElement.height)
            }
        }
    }
    
    class Thumb: ImageElementImpl {
        
        private let heightConstant: Float = Thumb.radius * 2.0
        
        required init(configurator: ElementViewConfigurator) {
            super.init(configurator: configurator)
            height = heightConstant
            width = heightConstant
            contentMode = .center
            corners = CornerRadius(value: heightConstant / 2.0)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        static var radius: Float = 15
          
        
        class Maker: ImageElementMaker<Thumb> {
            
        }
        
        override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
            let minSize: CGFloat = 44
            if bounds.width >= minSize && bounds.height >= minSize {
                return super.point(inside: point, with: event)
            }
            let verticalInsets = (minSize - bounds.height) / 2.0
            let horizontalInsets = (minSize - bounds.width) / 2.0

            let largerArea = CGRect(
                x: bounds.origin.x - horizontalInsets,
                y: bounds.origin.y - verticalInsets,
                width: bounds.width + 2.0 * horizontalInsets,
                height: bounds.height + 2.0 * verticalInsets
            )

            return largerArea.contains(point)
        }
    }
}

public struct ScoreTrackerElementProps: Equatable {
    let score: Float
}
