//
//  Extensions+UITableView.swift
//  BaseLibrary
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation
import UIKit

public extension UITableView {
    
    /// Đăng kí cell cho tableView
    public func register<T: UITableViewCell>(cellType: T.Type, bundle: Bundle? = nil) {
        let className = cellType.className
        let nib = UINib(nibName: className, bundle: bundle)
        register(nib, forCellReuseIdentifier: className)
    }

    /// Đăng kí mảng cell cho tableView
    public func register<T: UITableViewCell>(cellTypes: [T.Type], bundle: Bundle? = nil) {
        cellTypes.forEach { register(cellType: $0, bundle: bundle) }
    }

    /// Custom Reuse cel
    public func dequeueReusableCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        return self.dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
