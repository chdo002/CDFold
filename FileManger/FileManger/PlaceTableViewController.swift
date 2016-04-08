//
//  PlaceTableViewController.swift
//  FileManger
//
//  Created by chdo on 16/3/13.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

class PlaceTableViewController: UITableViewController {

    
    // 父节点
    var parentNode: NodeModel!
    // 本页下节点
    var nodes = [NodeModel]()
    
    var isCopy = false
    
    var targetNodes : [Int: NodeModel]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "NodeCell", bundle: nil), forCellReuseIdentifier: "cell")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaceTableViewController.dismiss))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "保存", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(PlaceTableViewController.selectPlace))
    }
    
    func dismiss(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    /**
    设置本页父节点
    
    - parameter isCopy:      本vc是否为复制页
    - parameter parentNode:  父节点
    - parameter targetNodes: 需要被操作的node
    */
    func setNode(isCopy: Bool, parentNode: NodeModel, targetNodes : [Int: NodeModel]) {
        
        self.parentNode = parentNode   // 父节点
        self.targetNodes = targetNodes // 处理节点
        self.isCopy = isCopy           // 本页是否为复制页
        
        
        self.title = (isCopy ? "复制到/" : "移动到/") + parentNode.nodename!
        nodes = Node.getNode(by: parentNode.nodeID!) // 获取本页节点
    }
    
    // 保存到位置
    func selectPlace(){
        
        if isCopy { // 复制
            
            for node in self.targetNodes {
                if node.1.nodeID == self.parentNode.nodeID {
                    print("不能复制到本目录")
                    return
                }
            }
            
            Node.copyNode(Array(self.targetNodes.values), toNode: self.parentNode)
            NSNotificationCenter.defaultCenter().postNotificationName(addNodeNotification, object: nil)
        } else { // 移动
            for node in self.targetNodes {
                
                if node.1.nodeID == self.parentNode.nodeID {
                    print("不能移动到本目录")
                    return
                }
            }
            
            
            // 将目标节点们，移动到当前父节点下
            Node.moveNodes(Array(self.targetNodes.values), targetNode: self.parentNode)
            NSNotificationCenter.defaultCenter().postNotificationName(addNodeNotification, object: nil)

        }
            self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let node = self.nodes[indexPath.row]
        switch node.node_type! {
        case NodeType.file.rawValue :
            print("这是文件" + node.nodename!)
        case NodeType.fold.rawValue:
            let palce = PlaceTableViewController()
                palce.setNode(self.isCopy, parentNode: self.nodes[indexPath.row], targetNodes: targetNodes)
            self.navigationController?.pushViewController(palce, animated: true)
        default:
            return
        }
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.nodes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NodeCell
        let arr = NSMutableArray()
        arr.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "删除")
        cell.rightUtilityButtons = arr as [AnyObject]
//        cell.delegate = self
        cell.nodeImage.image = Int(nodes[indexPath.row].node_type!) == 0 ?  UIImage(named: "file") : UIImage(named: "fold")
        cell.nodeTitle.text = nodes[indexPath.row].nodename
        return cell
    }
    

    
}
