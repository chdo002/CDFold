//
//  MainViewController.swift
//  FileManger
//
//  Created by chdo on 16/3/11.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func goto(sender: UIButton) {

        let show = ShowTableVC()
            show.setNode(Node.getRootNode())
        self.navigationController?.pushViewController(show, animated: true)
    }

}
