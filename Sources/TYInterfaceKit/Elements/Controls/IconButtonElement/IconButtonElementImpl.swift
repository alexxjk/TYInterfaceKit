//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

open class IconButtonElementImpl: ElementControl, IconButtonElement {

    private let imageView = UIImageView()

    public var icon: UIImage {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image!
        }
    }
    
    public override var opacity: Float {
        get {
            return Float(alpha)
        }
        set {
            alpha = CGFloat(newValue)
            imageView.alpha = CGFloat(newValue)
        }
    }
    
    open override var intrinsicContentSize: CGSize {
        return frame.size
    }
    
    override open var tintColor: UIColor? {
        set {
            imageView.image = icon.withRenderingMode(.alwaysTemplate)
            imageView.tintColor = newValue
        }
        get {
            return imageView.tintColor == .clear ? nil : imageView.tintColor
        }
    }

    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        setupElements()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupElements() {

        func setupImageView() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .center
            addSubview(imageView)
            let constraints = [
                imageView.topAnchor.constraint(equalTo: topAnchor),
                imageView.rightAnchor.constraint(equalTo: rightAnchor),
                imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
                imageView.leftAnchor.constraint(equalTo: leftAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }

        setupImageView()
    }
}


