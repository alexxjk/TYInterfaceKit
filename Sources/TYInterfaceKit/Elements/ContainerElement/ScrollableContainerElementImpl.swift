//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

open class ScrollableContainerElementImpl: ElementView, ScrollableContainerElement, UIScrollViewDelegate {

    private let scrollView = UIScrollView()
    
    private var equalHeights: NSLayoutConstraint!
    
    private var equalWidths: NSLayoutConstraint!
    
    public var doOnScroll: ((_ verticalOffset: Float) -> Void)?
    
    public var axis: Axis = .vertical {
        didSet {
            switch axis {
            case .horizontal:
                equalWidths.isActive = false
                equalHeights.isActive = true
                scrollView.alwaysBounceVertical = false
            case .vertical:
                equalWidths.isActive = true
                equalHeights.isActive = false
                scrollView.alwaysBounceVertical = true
            }
        }
    }
    
    public var clip: Bool {
        get {
            return clipsToBounds
        }
        set {
            clipsToBounds = newValue
        }
    }
    
    public var contentInsetAdjustmentBehavior: UIScrollView.ContentInsetAdjustmentBehavior {
        get {
            return scrollView.contentInsetAdjustmentBehavior
        } set {
            scrollView.contentInsetAdjustmentBehavior = newValue
        }
    }
    
    public var insets: UIEdgeInsets = .zero {
        didSet {
            scrollView.contentInset = insets
        }
    }
    
    public var verticalOffset: Float {
        return Float(scrollView.contentOffset.y)
    }
    
    public required init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func removeAllChildren() {
        contentView?.removeAllElements()
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        doOnScroll?(Float(offset))
    }
    
    open override func setup() {
        super.setup()
        setupElements()
    }
    
    private func setupElements() {
        func setupScrollView() {
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.layoutMargins = .zero
            scrollView.directionalLayoutMargins = .zero
            scrollView.preservesSuperviewLayoutMargins = preservesSuperviewLayoutMargins
            scrollView.alwaysBounceVertical = false
            scrollView.backgroundColor = .clear
            scrollView.contentInset = insets
            scrollView.contentInsetAdjustmentBehavior = .never
            scrollView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1)
            scrollView.delegate = self
            addSubview(scrollView)
            let constraints = [
                scrollView.topAnchor.constraint(equalTo: topAnchor),
                scrollView.rightAnchor.constraint(equalTo: rightAnchor),
                scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
                scrollView.leftAnchor.constraint(equalTo: leftAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
        }
        
        func setupContentView() {
            contentView = ContainerElementImpl(configurator: ElementViewConfigurator(preservesSuperviewLayoutMargins: preservesSuperviewLayoutMargins))
            guard let contentView = contentView else { return }
            scrollView.addSubview(contentView)
            let constraints = [
                contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                contentView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
                contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                contentView.leftAnchor.constraint(equalTo: scrollView.leftAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            equalHeights = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
            equalWidths = contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            switch axis {
            case .horizontal:
                equalWidths.isActive = false
                equalHeights.isActive = true
                scrollView.alwaysBounceVertical = false
            case .vertical:
                equalWidths.isActive = true
                equalHeights.isActive = false
                scrollView.alwaysBounceVertical = true
            }
        }
        
        setupScrollView()
        setupContentView()
    }
    
    public enum Axis {
        case vertical
        case horizontal
    }
}

