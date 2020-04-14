//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol TextElement: Element {
    
    var text: String? { get set }
    
    var numberOfLines: Int? { get set }
    
    var minimumScaleFactor: Float? { get set }
    
    var textStyleFactory: TextStyleBuilder? { get set }
    
    func updateAttributes(forRange range: NSRange, with attributes: [NSAttributedString.Key : Any])
}

