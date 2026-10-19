 //
//  DeviceType.swift
//  BaseLibrary
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import UIKit

/// The device/display hosting a screen, separate from its available layout space.
public enum DeviceDisplayType: Int, CaseIterable {
    case watch = 0
    case iPhone = 1
    case iPad = 2
    // Raw value 3 is reserved for the removed generic Duo case.
    case duoInner = 4
    case duoOuter = 5
    case unspecified = -1

    /// Classifies the interface idiom only. A phone idiom cannot identify Duo.
    /// Supply a Duo case from the app's scene integration when it is known.
    public init(userInterfaceIdiom: UIUserInterfaceIdiom) {
        switch userInterfaceIdiom {
        case .phone:
            self = .iPhone
        case .pad:
            self = .iPad
        default:
            self = .unspecified
        }
    }

    public init(traitCollection: UITraitCollection) {
        self.init(userInterfaceIdiom: traitCollection.userInterfaceIdiom)
    }

    public var isDuo: Bool {
        switch self {
        case .duoInner, .duoOuter:
            return true
        default:
            return false
        }
    }
}

/// Describes the horizontal layout space that is currently available.
///
/// Prefer this over inferring layout from the hardware family. Also use the
/// containing view’s bounds when layout depends on exact available width.
public enum DeviceLayoutType: Int {
    case compact = 0
    case regular = 1
    case unspecified = 2

    public init(horizontalSizeClass: UIUserInterfaceSizeClass) {
        switch horizontalSizeClass {
        case .compact:
            self = .compact
        case .regular:
            self = .regular
        case .unspecified:
            self = .unspecified
        @unknown default:
            self = .unspecified
        }
    }

    public init(traitCollection: UITraitCollection) {
        self.init(horizontalSizeClass: traitCollection.horizontalSizeClass)
    }

    /// Use regular-width layouts for split views, sidebars, and wider grids.
    public var usesExpandedLayout: Bool {
        self == .regular
    }
}

public extension UITraitEnvironment {
    /// Layout classification for the receiver's current trait environment.
    ///
    /// Read this from the view or view controller that owns the UI so the value
    /// updates naturally when a device folds, unfolds, rotates, or resizes.
    var deviceLayoutType: DeviceLayoutType {
        DeviceLayoutType(traitCollection: traitCollection)
    }
}
