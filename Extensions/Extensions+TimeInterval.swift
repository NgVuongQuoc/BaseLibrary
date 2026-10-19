//
//  Extensions+TimeInterval.swift
//  BaseLibrary
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation

public extension TimeInterval {
    func toMinSec() -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.zeroFormattingBehavior = .pad

        if let formattedString = formatter.string(from: self) {
            return formattedString
        } else {
            return "Unknown"
        }
    }
}
