//
//  Extensions+NSLayoutDimension.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation

public extension NSLayoutDimension {
    
    @discardableResult
    public func set(to constant: CGFloat, priority: UILayoutPriority = .required) -> NSLayoutConstraint {
        
        let cons = constraint(equalToConstant: constant)
        cons.priority = priority
        cons.isActive = true
        return cons
    }
}
