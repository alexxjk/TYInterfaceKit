//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol ImageElement: Element {
    
    var image: UIImage? { get set }
    
    var contentMode: UIView.ContentMode { get set }
    
    var tintColor: UIColor? { get set }
}


