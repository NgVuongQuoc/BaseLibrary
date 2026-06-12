//
//  Extensions+UIScrollView.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import UIKit

public extension UIScrollView {
    public var minContentOffset: CGPoint {
        return CGPoint(
            x: -self.contentInset.left,
            y: -self.contentInset.top)
    }
    
    public var maxContentOffset: CGPoint {
        return CGPoint(
            x: self.contentSize.width - self.bounds.width + self.contentInset.right,
            y: self.contentSize.height - self.bounds.height + self.contentInset.bottom)
    }
}
