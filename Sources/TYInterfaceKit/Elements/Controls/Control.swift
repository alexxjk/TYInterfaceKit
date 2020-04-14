//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation

public protocol Control: Element {
    
    var isEnabled: Bool { get set }
    
    var doOnTap: (() -> Void)? { get }
    
}
