//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

open class ListElementImpl<TItem: Equatable, TItemElement: ListItemElementImpl<TItem>, TLoadingItemElement: ListLoadingItemElementImpl>: ElementView, ListElement, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    private var isLoading: Bool
    
    private var isNotLoading: Bool {
        return !isLoading
    }
    
    private var items: [TItem]?
    
    private var collectionView: UICollectionView!
    private let itemCellId = "itemCellId"
    private let itemCellAutoSizedId = "itemCellAutoSizedId"
    
    private var didHandleScrollToEnd = false
    
    private var lastOffset: CGFloat?
    
    private var configurator: ListElementViewConfigurator
    
    public var insets: UIEdgeInsets = .zero {
        didSet {
            guard collectionView != nil else {
                return
            }
            collectionView.contentInset = insets
        }
    }
    
    open var spacing: Float = 16
    
    open var animateOnReloading: Bool {
        return true
    }
    
    public var doOnScroll: ((_ offset: Float) -> Void)?
    
    public var doOnItemSelected: ((_ item: TItem) -> Void)?
    
    public var doOnScrolledToEnd: (() -> Void)?
    
    public required init(configurator: ElementViewConfigurator) {
        self.configurator = configurator as! ListElementViewConfigurator
        items = [TItem]()
        isLoading = false
        super.init(configurator: configurator)
        preservesSuperviewLayoutMargins = true
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func setup() {
        super.setup()
        setupElements()
    }
    
    public func update(with newItems: [TItem], animated: Bool) {
        moveToLoadedStateIfNeeded()
        let oldItems = items
        items = newItems
        reload(animated: animated, oldItems: animateOnReloading ? oldItems : nil)
        didHandleScrollToEnd = false
    }
    
    public func scrollToTop() {
        collectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
    }
    
    public func moveToLoadingState() {
//        didHandleScrollToEnd = false
        isLoading = true
        reload(animated: true, oldItems: animateOnReloading ? [] : nil)
    }
    
    open func configElement(element: TItemElement) {
        
    }
    
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let itemsCount = items?.count ?? 0
        if isLoading {
            return itemsCount + (itemsCount > 0 ? 5 : 7)
        } else {
            return itemsCount
        }
    }
    
    public func collectionView(
        _ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let id = configurator.autoSize ? itemCellAutoSizedId : itemCellId
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: id, for: indexPath)
        if configurator.autoSize {
            let cell = genericCell as! CollectionViewAutoSizedCell
            if isNotLoading, let item = items?[indexPath.item] {
                let element = TItemElement(model: item)
                cell.set(element: element)
                element.config()
                configElement(element: element)
                element.update()
            } else if isLoading {
                if let items = items, indexPath.item < items.count {
                   let element = TItemElement(model: items[indexPath.item])
                   element.setup()
                   cell.set(element: element)
                } else {
                   let element = TLoadingItemElement(configurator: ElementViewConfigurator())
                   cell.set(element: element)
                }
            }
            return cell
        } else {
            let cell = genericCell as! CollectionViewCell
            if isNotLoading, let item = items?[indexPath.item] {
                let element = TItemElement(model: item)
                configElement(element: element)
                element.update()
                cell.set(element: element)
                element.config()
                
            } else if isLoading {
                if let items = items, indexPath.item < items.count {
                   let element = TItemElement(model: items[indexPath.item])
                   element.setup()
                   cell.set(element: element)
                } else {
                   let element = TLoadingItemElement(configurator: ElementViewConfigurator())
                   cell.set(element: element)
                }
            }
            return cell
        }
       
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let items = items, isNotLoading else {
            return
        }
        let item = items[indexPath.item]
        doOnItemSelected?(item)
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        doOnScroll?(Float(offset))
        if let doOnScrolledToEnd = doOnScrolledToEnd,
        scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y + insets.top + insets.bottom <= 10, !didHandleScrollToEnd {
            didHandleScrollToEnd = true
            doOnScrolledToEnd()
        }
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        didHandleScrollToEnd = false
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            didHandleScrollToEnd = false
        }
    }
    
    private func moveToLoadedStateIfNeeded() {
        guard isLoading else {
            return
        }
        didHandleScrollToEnd = false
        isLoading = false
    }
    
    private func reload(animated: Bool, oldItems: [TItem]?) {
        saveOffset()
        if !animated {
            collectionView.reloadData()
        } else if let oldItems = oldItems {
            let diff = (items ?? []).difference(from: oldItems)
            var deletedItems = [IndexPath]()
            var insertedItems = [IndexPath]()
            for change in diff {
                switch change {
                case .insert(let offset, _, _):
                    insertedItems.append(IndexPath(row: offset, section: 0))
                case .remove(let offset, _, _):
                    deletedItems.append(IndexPath(row: offset, section: 0))
                }
            }
            reloadWithAnimation(deletedIndexPaths: deletedItems, insertedIndexPaths: insertedItems)
        } else {
            #if targetEnvironment(macCatalyst)
                self.collectionView.performBatchUpdates({ [weak self] in
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                }) { [weak self] _ in
                    if let lastOffset = self?.lastOffset {
                        self?.collectionView.contentOffset.y = lastOffset
                    }
                }
            #else
                self.collectionView.performUsingPresentationValues { [weak self] in
                    self?.collectionView.reloadSections(IndexSet(integer: 0))
                }
            #endif
        }
    }
    
    private func reloadWithAnimation(deletedIndexPaths: [IndexPath], insertedIndexPaths: [IndexPath]) {
        self.collectionView.performBatchUpdates({
            collectionView.deleteItems(at: deletedIndexPaths)
            collectionView.insertItems(at: insertedIndexPaths)
        })
    }
    
    private func setupElements() {
        
        func setupCollectionView() {
            let flowLayout = configurator.axis == .vertical ? VerticalFlowLayout() : (configurator.autoSize ? HorizontalAutoWidthFlowLayout() : HorizontalFlowLayout())
            flowLayout.scrollDirection = configurator.axis == .vertical ? .vertical : .horizontal
            if configurator.axis == .vertical {
                flowLayout.minimumLineSpacing = CGFloat(spacing)
                flowLayout.minimumInteritemSpacing = 0
            } else {
                flowLayout.minimumLineSpacing = CGFloat(spacing)
                flowLayout.minimumInteritemSpacing = CGFloat(spacing)
            }
            flowLayout.sectionInset = .zero
            collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
            collectionView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.contentInset = insets
            collectionView.indicatorStyle = .black
            collectionView.showsHorizontalScrollIndicator = false
            collectionView.contentInsetAdjustmentBehavior = .always
            collectionView.alwaysBounceHorizontal = configurator.axis == .horizontal
            collectionView.alwaysBounceVertical = configurator.axis == .vertical && configurator.alwaysBounce
            collectionView.backgroundColor = .clear
            collectionView.keyboardDismissMode = .onDrag
            collectionView.verticalScrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -1)
            collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: itemCellId)
            collectionView.register(CollectionViewAutoSizedCell.self, forCellWithReuseIdentifier: itemCellAutoSizedId)
            addSubview(collectionView)
            let constraints = [
                collectionView.topAnchor.constraint(equalTo: topAnchor),
                collectionView.rightAnchor.constraint(equalTo: rightAnchor),
                collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
                collectionView.leftAnchor.constraint(equalTo: leftAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            collectionView.delegate = self
            collectionView.dataSource = self
        }
        
        setupCollectionView()
    }
    
    private func saveOffset() {
        if configurator.axis == .vertical {
            lastOffset = collectionView.contentOffset.y
        } else {
            lastOffset = collectionView.contentOffset.x
        }
    }
    
    private class CollectionViewAutoSizedCell: UICollectionViewCell {
        private var elementView: ElementView?
        
        override var isHighlighted: Bool {
            didSet {
                toggleIsHighlighted()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            directionalLayoutMargins = NSDirectionalEdgeInsets(
                top: 0,
                leading: 0,
                bottom: 0,
                trailing: 0
            )
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        

        func set(element: ElementView) {
            elementView?.removeFromSuperview()
            elementView = element
            contentView.addSubview(element)
            let constraints = [
                element.topAnchor.constraint(equalTo: contentView.topAnchor),
                element.rightAnchor.constraint(equalTo: contentView.rightAnchor),
                element.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
                element.leftAnchor.constraint(equalTo: contentView.leftAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            layoutIfNeeded()
        }
        
        override func preferredLayoutAttributesFitting(
            _ layoutAttributes: UICollectionViewLayoutAttributes
        ) -> UICollectionViewLayoutAttributes {
            let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
            layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .fittingSizeLevel,
                verticalFittingPriority: .fittingSizeLevel
            )
            return layoutAttributes
        }

        func toggleIsHighlighted() {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
                self.alpha = self.isHighlighted ? 0.9 : 1.0
                self.transform = self.isHighlighted ?
                    CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                    CGAffineTransform.identity
            })
        }
    }
    
    private class CollectionViewCell: UICollectionViewCell {
        
        private var elementView: ElementView?
        
        override var isHighlighted: Bool {
            didSet {
                toggleIsHighlighted()
            }
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            directionalLayoutMargins = NSDirectionalEdgeInsets(
                top: layoutMargins.top,
                leading: layoutMargins.left,
                bottom: layoutMargins.bottom,
                trailing: layoutMargins.right
            )
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        

        func set(element: ElementView) {
            elementView?.removeFromSuperview()
            elementView = element
            contentView.addSubview(element)
            let heightConstraint = contentView.heightAnchor.constraint(equalTo: element.heightAnchor)
            heightConstraint.priority = .defaultHigh
            let constraints = [
                heightConstraint,
                element.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
                element.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
                element.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
            ]
            NSLayoutConstraint.activate(constraints)
            layoutIfNeeded()
        }
        
        override func preferredLayoutAttributesFitting(
            _ layoutAttributes: UICollectionViewLayoutAttributes
        ) -> UICollectionViewLayoutAttributes {
            let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
            layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(
                targetSize,
                withHorizontalFittingPriority: .required,
                verticalFittingPriority: .fittingSizeLevel
            )
            return layoutAttributes
        }

        func toggleIsHighlighted() {
            UIView.animate(withDuration: 0.1, delay: 0, options: [.curveEaseOut], animations: {
                self.alpha = self.isHighlighted ? 0.9 : 1.0
                self.transform = self.isHighlighted ?
                    CGAffineTransform.identity.scaledBy(x: 0.97, y: 0.97) :
                    CGAffineTransform.identity
            })
        }
    }
    
    private class VerticalFlowLayout: UICollectionViewFlowLayout {

        override init() {
            super.init()
            estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
            guard let collectionView = collectionView else { return nil }
            guard collectionView.frame.height > 0 else {
                return nil
            }
            layoutAttributes.bounds.size.width =
                collectionView.frame.width -
                sectionInset.left -
                sectionInset.right -
                collectionView.contentInset.left -
                collectionView.contentInset.right - 0.5
            return layoutAttributes
        }

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let superLayoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

            let computedAttributes = superLayoutAttributes.compactMap { layoutAttribute in
                return layoutAttributesForItem(at: layoutAttribute.indexPath)
            }
            return computedAttributes
        }
    }
    
    private class HorizontalAutoWidthFlowLayout: UICollectionViewFlowLayout {
        override init() {
            super.init()
            estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            scrollDirection = .horizontal
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    private class HorizontalFlowLayout: UICollectionViewFlowLayout {
        
        override init() {
            super.init()
            estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
            guard let layoutAttributes = super.layoutAttributesForItem(at: indexPath) else { return nil }
            guard let collectionView = collectionView else { return nil }
            guard collectionView.frame.height > 0 else {
                return nil
            }
            let collectionViewWidth = collectionView.frame.width - sectionInset.left - sectionInset.right - collectionView.contentInset.left - collectionView.contentInset.right - 0.5
            let totalWidth = collectionViewWidth - minimumLineSpacing
            layoutAttributes.bounds.size.width = totalWidth * 0.67
            return layoutAttributes
        }

        override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
            guard let superLayoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }

            let computedAttributes = superLayoutAttributes.compactMap { layoutAttribute in
                return layoutAttributesForItem(at: layoutAttribute.indexPath)
            }
            return computedAttributes
        }
    }
}

open class ListItemElementImpl<TItem>: ElementView {
    
    public let model: TItem
    
    open var paddings: NSDirectionalEdgeInsets {
        return .zero
    }
    
    public required init(model: TItem) {
        self.model = model
        super.init(configurator: ElementViewConfigurator())
        directionalLayoutMargins = paddings
        setup()
        update(with: model)
    }
    
    required public init(configurator: ElementViewConfigurator) {
        fatalError()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        update(with: model)
    }
    
    open func update(with model: TItem) {
        
    }
    
    open func config() {
        
    }
}

open class ListLoadingItemElementImpl: ElementView {
    required public init(configurator: ElementViewConfigurator) {
        super.init(configurator: configurator)
        UIView.animate(withDuration: 0.5, delay: 0, options: [.repeat, .autoreverse], animations: {
            self.alpha = 0.5
        }, completion: nil)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

public class ListElementViewConfigurator: ElementViewConfigurator {
    
    public let axis: ListElementAxis
    
    public let alwaysBounce: Bool
    
    public let autoSize: Bool
    
    public init(
        axis: ListElementAxis = .vertical,
        alwaysBounce: Bool,
        preservesSuperviewLayoutMargins: Bool = false,
        autoSize: Bool = false
    ) {
        self.axis = axis
        self.alwaysBounce = alwaysBounce
        self.autoSize = autoSize
        super.init(preservesSuperviewLayoutMargins: preservesSuperviewLayoutMargins)
    }
}

