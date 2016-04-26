//
//  TabbarViewController.swift
//  FileManger
//
//  Created by chdo on 16/4/15.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

class TabbarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.barTintColor = UIColor.blackColor()
        self.tabBar.translucent = false
        self.tabBar.tintColor = UIColor.whiteColor()
    }

    
}
