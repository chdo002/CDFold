//
//  ProductNavigationVC.swift
//  FileManger
//
//  Created by chdo on 16/4/13.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

class ProductNavigationVC: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.barStyle = .Black
        self.navigationBar.translucent = false
        
        self.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor(),NSFontAttributeName: UIFont.systemFontOfSize(16, weight: UIFontWeightLight)]
     
        self.navigationBar.tintColor = UIColor.whiteColor()
    }
    
    override func setNeedsStatusBarAppearanceUpdate() {
        super.setNeedsStatusBarAppearanceUpdate()
        
    }
    
    

}
