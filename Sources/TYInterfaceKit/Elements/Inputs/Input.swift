//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

public protocol Input: Element {
    var doOnValueChanged: (() -> Void)? { get }
}

