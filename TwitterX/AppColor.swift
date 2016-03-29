//
//  AppColor.swift
//  Twitter
//
//  Created by Tien on 3/26/16.
//  Copyright © 2016 tiennth. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class func appPrimaryColor() -> UIColor {
        return UIColor(red: 88/255.0, green: 175/255.0, blue: 240/255.0, alpha: 1)
    }
    
    class func colorWithHex(hex:Int) -> UIColor {
        return UIColor(red: CGFloat((hex>>16)&0xFF)/255.0, green: CGFloat((hex>>8)&0xFF)/255.0, blue: CGFloat(hex&0xFF)/255.0, alpha: 1)
    }
}
