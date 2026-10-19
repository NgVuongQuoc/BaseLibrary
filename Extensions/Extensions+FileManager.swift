//
//  Extensions+FileManager.swift
//  BaseLibrary
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation

public extension FileManager {
    public func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
