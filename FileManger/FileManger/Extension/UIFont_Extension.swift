//
//  UIFont_Extension.swift
//  EZY3D
//
//  Created by chdo on 15/11/5.
//  Copyright © 2015年 YingWei. All rights reserved.
//

import Foundation

extension UIFont {
    class func winnie(size: CGFloat) -> UIFont{
//        if #available(iOS 8.2, *) {
//            return UIFont.systemFontOfSize(size, weight: UIFontWeightLight)
//        } else {
            return UIFont.systemFontOfSize(size)
//        }
    }
}