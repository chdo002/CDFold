//
//  UIViewController_Extension.swift
//  EZY3D
//
//  Created by chdo on 16/1/17.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

extension UIViewController {
    func showAlert(title: String?, message: String?, preferredStyle: UIAlertControllerStyle, actionTitle: String?, handler: ((UIAlertAction) -> Void)?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: preferredStyle)
        let action = UIAlertAction(title: actionTitle, style: .Cancel, handler: handler)
        alert.addAction(action)
        self.presentViewController(alert, animated: true, completion: nil)
    }
}
