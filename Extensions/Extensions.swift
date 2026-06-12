//
//  Extensions.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation
import UIKit

public protocol AnyOptional {
    var isNil: Bool { get }
    var isNotNil: Bool { get }
}

public extension NSObject {
    public var className: String {
        return String(describing: type(of: self))
    }
    
    class public var className: String {
        return String(describing: self)
    }
}

extension Optional: AnyOptional {
    public var isNil: Bool { self == nil }
    public var isNotNil: Bool { self != nil }
}

public extension Optional where Wrapped: Collection {
    public var isNilOrEmpty: Bool {
        return self?.isEmpty ?? true
    }
}
