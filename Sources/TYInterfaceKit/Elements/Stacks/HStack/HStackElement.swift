//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol HStackElement: ContainerElement {
   
    var spacing: Float { get set }
    
    var leadingPadding: Float { get set }
    
    var distribution: UIStackView.Distribution { get set }
}


