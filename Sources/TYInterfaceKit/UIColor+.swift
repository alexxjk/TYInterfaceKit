//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import UIKit

extension UIColor {
    convenience init(hex: Int, alpha: CGFloat = 1) {
        func normalize(_ value: CGFloat) -> CGFloat {
            return value / 255.0
        }
        let r = normalize(CGFloat((hex >> 16) & 0xFF))
        let g = normalize(CGFloat((hex >> 8) & 0xFF))
        let b = normalize(CGFloat(hex & 0xFF))
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
}

