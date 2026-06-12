//
//  Constants.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import Foundation
import UIKit

public let IS_IPAD = UIDevice.current.userInterfaceIdiom == .pad
public let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""

public let ITEM_PER_ROW: CGFloat = IS_IPAD ? 3 : 2
public let SPACING_PER_ROW: CGFloat = IS_IPAD ? 4 : 3

public enum DataCatalogue: Int {
    case All = 0
    case Live = 1
    case Wallpaper = 2
}
