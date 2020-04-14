//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol VStackElement: ContainerElement {
   
    var spacing: Float { get set }
    
    var topPadding: Float { get set }
}

