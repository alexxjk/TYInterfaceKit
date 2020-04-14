//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol TitleButtonElement: Control {
    
    var title: String { get set }
    
    var textStyleFactory: TextStyleBuilder? { get set }
}
