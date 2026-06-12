//
//  Extensions+UIFont.swift
//  InternalSports
//
//  Created by Nguyen Vuong Quoc on 12/6/26.
//

import UIKit

public extension UIFont {
    
    public class func boldWith(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Bold", size: size)!
    }
    
    public class func mediumWith(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Medium", size: size)!
    }
    
    public class func regularWith(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Regular", size: size)!
    }
    
    public class func semiBoldWith(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-SemiBold", size: size)!
    }
    
    public class func blackWith(_ size: CGFloat) -> UIFont {
        return UIFont(name: "Inter-Black", size: size)!
    }
    
}
