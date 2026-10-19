//
//  Constants.swift
//  BaseLibrary
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation
import UIKit

public let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
public let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""

@available(*, deprecated, message: "Use itemPerRow(for:) with the current trait collection so layouts adapt when available width changes.")
public let ITEM_PER_ROW: CGFloat = IS_IPAD ? 3 : 2

@available(*, deprecated, message: "Use spacingPerRow(for:) with the current trait collection so layouts adapt when available width changes.")
public let SPACING_PER_ROW: CGFloat = IS_IPAD ? 4 : 3

public func itemPerRow(for traitCollection: UITraitCollection) -> CGFloat {
    DeviceLayoutType(traitCollection: traitCollection).usesExpandedLayout ? 3 : 2
}

public func spacingPerRow(for traitCollection: UITraitCollection) -> CGFloat {
    DeviceLayoutType(traitCollection: traitCollection).usesExpandedLayout ? 4 : 3
}

public enum DataCatalogue: Int {
    case All = 0
    case Live = 1
    case Wallpaper = 2
}
