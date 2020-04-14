//
//  File.swift
//  
//
//  Created by Alexander Martirosov on 4/14/20.
//

import Foundation
import UIKit

/**
 Text Style factory
*/
final public class TextStyleBuilder {
    
    public init() { }
    
    private var font: UIFont = .systemFont(ofSize: 12)
    
    private var color: UIColor = .black
    
    private var line: CGFloat?
    
    private var character: CGFloat?
    
    private var alignment: NSTextAlignment = .left
    
    private var lineBreakMode: NSLineBreakMode = .byTruncatingTail
    
    /**
     Font
    */
    public func font(_ font: UIFont) -> TextStyleBuilder {
        self.font = font
        return self
    }
    
    /**
     Text color
    */
    public func color(_ color: UIColor) -> TextStyleBuilder {
        self.color = color
        return self
    }
    
    /**
     Line height (leading)
    */
    public func line(_ line: CGFloat) -> TextStyleBuilder {
        self.line = line
        return self
    }
    
    /**
     Letter spacing
    */
    public func character(_ character: CGFloat) -> TextStyleBuilder {
        self.character = character
        return self
    }
    
    /**
     Alignment
    */
    public func alignment(_ alignment: NSTextAlignment) -> TextStyleBuilder {
        self.alignment = alignment
        return self
    }
    
    /**
     Line break mode
    */
    public func lineBreakMode(_ lineBreakMode: NSLineBreakMode) -> TextStyleBuilder {
        self.lineBreakMode = lineBreakMode
        return self
    }
    
    public func make(text: String) -> NSAttributedString {
        let attributes = makeAttributes()
        return NSAttributedString(string: text, attributes: attributes)
    }
    
    public func makeMutable(text: String) -> NSMutableAttributedString {
        let attributes = makeAttributes()
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    public func makeAttributes() -> [NSAttributedString.Key: Any] {
        var attributes = [NSAttributedString.Key: Any]()
        let paragraphStyle = NSMutableParagraphStyle()
        if let line = line {
            paragraphStyle.minimumLineHeight = line
            paragraphStyle.maximumLineHeight = line
        }
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        attributes[.foregroundColor] = self.color
        attributes[.paragraphStyle] = paragraphStyle
        if let character = character {
            attributes[.kern] = character
        }
        attributes[.font] = font
        return attributes
    }
    
    static func `default`() -> TextStyleBuilder {
        return TextStyleBuilder().font(UIFont.systemFont(ofSize: 14)).color(.darkText)
    }
}

