//
//  CustomAttributedStringCreator.swift
//  Mei
//
//  Created by Erica Gutierrez on 9/3/19.
//  Copyright © 2019 Erica Gutierrez. All rights reserved.
//

import UIKit

enum HelveticaStyle {
    case helveticaNeue
    case helveticaNeueBold
    case helveticaNeueLight
    case helveticaNeueItalic
}

struct AStringCreator {
    
    private init() {}
    
    static func helveticaAString(style: HelveticaStyle, text: String, size: CGFloat, foregroundColor: UIColor, backgroundColor: UIColor) -> NSAttributedString {
        let fontNameString: String
        switch style {
        case .helveticaNeue:
            fontNameString = "HelveticaNeue"
        case .helveticaNeueBold:
            fontNameString = "HelveticaNeue-Bold"
        case .helveticaNeueItalic:
            fontNameString = "HelveticaNeue-Italic"
        case .helveticaNeueLight:
            fontNameString = "HelveticaNeue-Light"
        }
        
        let attribute: [NSAttributedString.Key : Any]
        if let font = UIFont(name: fontNameString, size: size) {
            attribute = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: foregroundColor, NSAttributedString.Key.backgroundColor: backgroundColor]
        } else {
            attribute = [NSAttributedString.Key.foregroundColor: foregroundColor, NSAttributedString.Key.backgroundColor: backgroundColor]
        }
        return NSAttributedString(string: text, attributes: attribute)
    }
    
    static func helveticaAString(style: HelveticaStyle, text: String, size: CGFloat, foregroundColor: UIColor, backgroundColor: UIColor, alignment: NSTextAlignment) -> NSAttributedString {
        let fontNameString: String
        switch style {
        case .helveticaNeue:
            fontNameString = "HelveticaNeue"
        case .helveticaNeueBold:
            fontNameString = "HelveticaNeue-Bold"
        case .helveticaNeueItalic:
            fontNameString = "HelveticaNeue-Italic"
        case .helveticaNeueLight:
            fontNameString = "HelveticaNeue-Light"
        }
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        let attribute: [NSAttributedString.Key : Any]
        if let font = UIFont(name: fontNameString, size: size) {
            attribute = [
                NSAttributedString.Key.font: font,
                NSAttributedString.Key.foregroundColor: foregroundColor,
                NSAttributedString.Key.backgroundColor: backgroundColor,
                NSAttributedString.Key.paragraphStyle: paragraph]
        } else {
            attribute = [
                NSAttributedString.Key.foregroundColor: foregroundColor,
                NSAttributedString.Key.backgroundColor: backgroundColor,
                NSAttributedString.Key.paragraphStyle: paragraph]
        }
        return NSAttributedString(string: text, attributes: attribute)
    }
}
