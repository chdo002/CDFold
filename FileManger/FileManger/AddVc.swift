//
//  AddVc.swift
//  FileManger
//
//  Created by chdo on 16/3/11.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

let addNodeNotification = "addNodeNotification"

class AddVc: UIViewController {
    
    var parentNode: NodeModel!
    
    var typeLabel: UILabel!
    var name: UITextField!
    var type: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        
        let but = UIButton()
            but.setTitle("关闭", forState: UIControlState.Normal)
            but.backgroundColor = UIColor.redColor()
            but.tintColor = UIColor.whiteColor()
            but.addTarget(self, action: "dissmiss", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(but)
            but.snp_makeConstraints { (make) -> Void in
                make.size.equalTo(CGSizeMake(50, 50))
                make.left.equalTo(self.view.snp_left).offset(2)
                make.top.equalTo(self.view.snp_top).offset(50)
            }
        
        let save = UIButton()
            save.setTitle("保存", forState: UIControlState.Normal)
            save.backgroundColor = UIColor.brownColor()
            save.tintColor = UIColor.whiteColor()
            save.addTarget(self, action: "save", forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(save)
            save.snp_makeConstraints { (make) -> Void in
                make.size.equalTo(CGSizeMake(50, 50))
                make.right.equalTo(self.view.snp_right).offset(-2)
                make.top.equalTo(self.view.snp_top).offset(50)
            }
        
        name = UITextField()
        view.addSubview(name)
        name.backgroundColor = UIColor.redColor()
        name.placeholder = "填入文件或文件夹名"
        name.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.centerY.equalTo(self.view).offset(-150)
            make.size.equalTo(CGSizeMake(self.view.frame.width * 0.8, 40))
        }
        
        type = UISwitch()
            view.addSubview(type)
            type.addTarget(self, action: "switchValuedChanged:", forControlEvents: UIControlEvents.ValueChanged)
        type.snp_makeConstraints { (make) -> Void in
            make.centerX.equalTo(self.view)
            make.top.equalTo(name.snp_bottom).offset(50)
            make.size.equalTo(CGSizeMake(100, 50))
        }
        
            typeLabel = UILabel()
            typeLabel.text = "文件"
            typeLabel.backgroundColor = UIColor.greenColor()
            typeLabel.contentMode = .Center
            view.addSubview(typeLabel)
        typeLabel.snp_makeConstraints { (make) -> Void in
            make.centerY.equalTo(type)
            make.right.equalTo(type.snp_left)
            make.size.equalTo(CGSizeMake(100, 50))
        }
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        name.resignFirstResponder()
    }
    
    func setNode(parentNode: NodeModel) {
        self.parentNode = parentNode
    }

    override func viewDidAppear(animated: Bool) {
        self.name.becomeFirstResponder()
    }
    func save(){
        
        guard self.name.text != nil else {
            print("文件名没填")
            return
        }
        
        let newNode = NodeModel(data: [
            "nodeID" : "\(NSDate.timeStamp())",
            "nodename":name.text!,
            "parentID": parentNode.nodeID!,
            "node_type": !type.on ? "0" : "1"
            ])
        if Node.saveNode(newNode) {
            NSNotificationCenter.defaultCenter().postNotificationName(addNodeNotification, object: nil)
            self.dismissViewControllerAnimated(true, completion: { () -> Void in
            })
        } else {
            print("出错了")
        }
    }
    
    func dissmiss(){
        self.dismissViewControllerAnimated(true) { () -> Void in

        }
    }
    
    func switchValuedChanged(swic: UISwitch){
        typeLabel.text = !swic.on ? "文件" : "文件夹"
    }
}



extension NSDate {
    class func timeStamp() -> Int{
        let ss = Int(NSDate().timeIntervalSince1970 * 1000)
        return ss
    }
}
