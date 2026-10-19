//
//  Extensions+UILabel.swift
//  BaseLibrary
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation
import UIKit

public extension UILabel {
    public func halfTextColorChange(fullText: String, changeText: String, colorChange: UIColor) {
        let strNumber: NSString = fullText as NSString
        let range = (strNumber).range(of: changeText)
        let attribute = NSMutableAttributedString.init(string: fullText)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: colorChange , range: range)
        self.attributedText = attribute
    }
    
    public func setLineSpacing(lineHeight: CGFloat = 0.0,
                        alignment: NSTextAlignment = .left,
                        lineSpace: CGFloat = 0.0,
                        lineBreakMode: NSLineBreakMode = .byWordWrapping) {
        guard let labelText = text else { return }
        let paragraphStyle = NSMutableParagraphStyle()
        
        let lineHeightMultiple = lineHeight / font.lineHeight
        
        paragraphStyle.lineHeightMultiple = lineHeightMultiple
        paragraphStyle.lineSpacing = lineSpace / 2
        paragraphStyle.alignment = alignment
        paragraphStyle.lineBreakMode = lineBreakMode
        
        let attributedString: NSMutableAttributedString = {
            if let labelattributedText = attributedText {
                return NSMutableAttributedString(attributedString: labelattributedText)
            }
            return NSMutableAttributedString(string: labelText)
        }()
        
        attributedString.addAttribute(.paragraphStyle,
                                      value: paragraphStyle,
                                      range: NSRange(location: 0, length: attributedString.length))
        attributedText = attributedString
    }
    
    public func setLineSpacing(lineSpacing: CGFloat = 0.0, lineHeightMultiple: CGFloat = 0.0) {

        guard let labelText = self.text else { return }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.lineHeightMultiple = lineHeightMultiple

        let attributedString:NSMutableAttributedString
        if let labelattributedText = self.attributedText {
            attributedString = NSMutableAttributedString(attributedString: labelattributedText)
        } else {
            attributedString = NSMutableAttributedString(string: labelText)
        }

        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))

        self.attributedText = attributedString
    }
}
