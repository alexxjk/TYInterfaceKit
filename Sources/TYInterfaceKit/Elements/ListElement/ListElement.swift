//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

public protocol ListElement: Element {
    
    associatedtype TItem: Equatable
    
    var insets: UIEdgeInsets { get }
    
    var spacing: Float { get }
    
    var animateOnReloading: Bool { get }
    
    var doOnScroll: ((_ offset: Float) -> Void)? { get }
    
    var doOnItemSelected: ((_ item: TItem) -> Void)? { get }
    
    var doOnScrolledToEnd: (() -> Void)? { get }
    
    func update(with newItems: [TItem], animated: Bool)
    
    func scrollToTop()
    
    func moveToLoadingState()
}


public enum ListElementAxis {
    case vertical
    case horizontal
}


