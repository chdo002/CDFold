//
//  UIView_Extension.swift
//  EZY3D
//
//  Created by chdo on 15/10/10.
//  Copyright © 2015年 YingWei. All rights reserved.
//

import UIKit
extension UIView {
    // 获取当前view的截屏
    func getImage() ->UIImage{
        UIGraphicsBeginImageContext(self.bounds.size)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, false, UIScreen.mainScreen().scale)
        self.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
    }
    
    func copyOfSelf() ->UIView {
        let temp = NSKeyedArchiver.archivedDataWithRootObject(self)
        return NSKeyedUnarchiver.unarchiveObjectWithData(temp) as! UIView
    }
}
