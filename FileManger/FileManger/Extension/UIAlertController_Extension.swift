//
//  UIAlertController_Extension.swift
//  EZY3D
//
//  Created by chdo on 16/3/1.
//  Copyright © 2016年 yw. All rights reserved.
//

import Foundation

extension UIAlertController {
    class func cdAlert(title: String?, message: String?,
                       butTitle1: String, actionBlock1: ((UIAlertAction) -> Void)?,
                       butTitle2: String, actionBlock2: ((UIAlertAction) -> Void)?) -> UIAlertController
    {
        let alert   = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let aciton1 = UIAlertAction(title: butTitle1, style: UIAlertActionStyle.Cancel, handler: actionBlock1)
        let aciton2 = UIAlertAction(title: butTitle2, style: UIAlertActionStyle.Default, handler: actionBlock2)
        alert.addAction(aciton1)
        alert.addAction(aciton2)
        return alert
    }
}