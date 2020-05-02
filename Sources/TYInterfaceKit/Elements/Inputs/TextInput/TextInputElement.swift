//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol TextInputElement: Input {
    
    var value: String? { get set }
    
    var textStyleFactory: TextStyleBuilder { get set }
    
    var placeholderText: String? { get set }
    
    var doOnValueChanged: (() -> Void)? { get set }
    
    func makeFirstResponder()

}

public protocol SinglelineTextInputElement: TextInputElement {
    
    var icon: UIImage? { get set }
    
}

