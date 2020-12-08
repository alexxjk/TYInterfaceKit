//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

open class ImageElementImpl: ElementView, ImageElement {

    private let imageView = UIImageView()

    public var image: UIImage? {
        set {
            imageView.image = newValue
        }
        get {
            return imageView.image
        }
    }

    open override var contentMode: ContentMode {
        set {
            imageView.contentMode = newValue
        }
        get {
            return imageView.contentMode
        }
    }
    
    override open var tintColor: UIColor? {
        set {
            if let tintColor = newValue {
                imageView.image = image?.withRenderingMode(.alwaysTemplate)
                imageView.tintColor = tintColor
            } else {
                imageView.image = image?.withRenderingMode(.alwaysOriginal)
            }
        }
        get {
            return imageView.tintColor == .clear ? nil : imageView.tintColor
        }
    }

    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        contentMode = .scaleAspectFit
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        setupElements()
    }

    private func setupElements() {

        func setupImageView() {
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
            imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
            imageView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            addSubview(imageView)
            let bc = imageView.bottomAnchor.constraint(equalTo: bottomAnchor)
            bc.priority = .defaultLow
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

