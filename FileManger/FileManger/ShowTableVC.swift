//
//  ShowTableVC.swift
//  FileManger
//
//  Created by chdo on 16/3/11.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit


// 节点展示页

class ShowTableVC: UITableViewController, SWTableViewCellDelegate {
    

    // 父节点
    var parentNode: NodeModel!
    // 本页下节点
    var nodes = [NodeModel]()
    //待处理节点
    lazy var workingNodes = [Int: NodeModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "refreshNode", name: addNodeNotification, object: nil)
        let item1 = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: "add:")
        let item2 = UIBarButtonItem(title: "选择", style: UIBarButtonItemStyle.Plain, target: self, action: "select")
        self.navigationItem.rightBarButtonItems = [item1, item2]
        
        tableView.registerNib(UINib(nibName: "NodeCell", bundle: nil), forCellReuseIdentifier: "cell")

        let tItem1 = UIBarButtonItem(title: "复制", style: UIBarButtonItemStyle.Plain, target: self, action: "tool1:")
            tItem1.tag = 1
        let tItem2 = UIBarButtonItem(title: "移动到", style: UIBarButtonItemStyle.Plain, target: self, action: "tool1:")
            tItem2.tag = 2
        let tItem3 = UIBarButtonItem(title: "删除", style: UIBarButtonItemStyle.Plain, target: self, action: "tool1:")
            tItem3.tag = 3
        let tItem4 = UIBarButtonItem(title: "组成文件夹", style: UIBarButtonItemStyle.Plain, target: self, action: "tool1:")
            tItem4.tag = 4
        let fix = UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target: nil, action: nil)
        self.toolbarItems = [fix, tItem1, fix, tItem2, fix, tItem3, fix, tItem4, fix]
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.toolbarHidden = true
        self.tableView.editing = false
    }

    // 设置本页父节点
    func setNode(parentNode: NodeModel) {
        self.parentNode = parentNode
        self.title = parentNode.nodename
        nodes = Node.getNode(by: parentNode.nodeID!)
        
    }
    // MARK:- 刷新tableview
    func refreshNode(){
        nodes = Node.getNode(by: parentNode.nodeID!)
        self.tableView.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return nodes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! NodeCell
        let arr = NSMutableArray()
            arr.sw_addUtilityButtonWithColor(UIColor.brownColor(), title: "删除")
            cell.rightUtilityButtons = arr as [AnyObject]
            cell.delegate = self
            cell.nodeImage.image = Int(nodes[indexPath.row].node_type!) == 0 ?  UIImage(named: "file") : UIImage(named: "fold")
            cell.nodeTitle.text = nodes[indexPath.row].nodename
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        
        if tableView.editing {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
                cell?.setSelected(true, animated: true)
            self.workingNodes[indexPath.row] = self.nodes[indexPath.row]
        } else {
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            let node = self.nodes[indexPath.row]
            switch node.node_type! {
            case NodeType.file.rawValue :
                print("这是文件" + node.nodename!)
            case NodeType.fold.rawValue:
                let showTable = ShowTableVC()
                showTable.setNode(self.nodes[indexPath.row])
                self.navigationController?.pushViewController(showTable, animated: true)
            default:
                return
            }
        }
    }
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        self.workingNodes.removeValueForKey(indexPath.row)
    }
    // MARK:- 滑动cell delegate
    func swipeableTableViewCell(cell: SWTableViewCell!, didTriggerRightUtilityButtonWithIndex index: Int)
    {
        let ind = tableView.indexPathForCell(cell)
        Node.deleteFold([self.nodes[ind!.row]])
        nodes.removeAtIndex(ind!.row)
        tableView.deleteRowsAtIndexPaths([ind!], withRowAnimation: UITableViewRowAnimation.Automatic)

    }
    
    // MARK:- 跳转添加节点页
    func add(but: UIBarButtonItem) {
        
        let vc = AddVc()
            vc.setNode(self.parentNode)
        self.presentViewController(vc, animated: true) { () -> Void in
        }
    }
    // MARK:- 切换选择状态
    func select(){
        self.tableView.allowsMultipleSelectionDuringEditing = true
        self.tableView.setEditing(!self.tableView.editing, animated: true)
        self.navigationController?.setToolbarHidden(!self.tableView.editing, animated: true)
    }
    
    // MARK:- 节点处理
    func tool1(tItem: UIBarButtonItem){
        switch tItem.tag {
        case 1, 2:
            let vc = UIStoryboard(name: "Fouction", bundle: nil).instantiateViewControllerWithIdentifier("root") as! UINavigationController
            let move = vc.viewControllers.first as! PlaceTableViewController

            if tItem.tag == 1 { // 复制
                move.setNode(true, parentNode: Node.getRootNode(), targetNodes: self.workingNodes)
            } else {  // 移动
                move.setNode(false, parentNode: Node.getRootNode(), targetNodes: self.workingNodes)
            }

            self.presentViewController(vc, animated: true, completion: { () -> Void in
            })
        case 3: // 删除
            Node.deleteFold(Array(self.workingNodes.values))
            self.refreshNode()
        case 4: // 组成文件夹
            Node.addNewFolds(Array(self.workingNodes.values))
            self.refreshNode()            
        default:
            return
        }
    }
    
}