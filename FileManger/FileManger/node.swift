//
//  node.swift
//  FileManger
//
//  Created by chdo on 16/3/11.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit


class Node: BaseDao, IBaseDao {
    // MARK:-
    static func createTable(db: FMDatabase) -> Bool {
        let createTableSql =
        "CREATE TABLE TB_Node ( " +
            " nodeID VARCHAR(200) PRIMARY KEY ," +
            " nodename VARCHAR(200) ," +
            " parentID VARCHAR(200) ," +
            " node_Level VARCHAR(200) ," +
            " code_Level VARCHAR(200) ," +
            " node_type VARCHAR(200)" +
         ")"
        
        if !db.executeUpdate(createTableSql, withArgumentsInArray: []) {
            appLog.error("创建用户表失败 failure: \(db.lastError())")
            return false
        } else {
            appLog.debug("创建用户表成功")
            return true
        }
    }
    
    
    // MARK:- 获得根节点
    class func getRootNode() -> NodeModel{
        let sql = "select * from TB_Node where parentID = ? and nodeID = ?"
        let arg = [0,rootNodeID]
        var rootnode : NodeModel!
        DBManager.shareInstance().executeQuery(sql, args: arg) { (resultSet, error) -> Void in
            if error == nil {
                while resultSet!.next() {
                    let node = NodeModel()
                    node.nodeID = resultSet?.stringForColumn("nodeID")
                    node.parentID = resultSet?.stringForColumn("parentID")
                    node.node_Level = resultSet?.stringForColumn("node_Level")
                    node.code_Level = resultSet?.stringForColumn("code_Level")
                    node.node_type = resultSet?.stringForColumn("node_type")
                    node.nodename = resultSet?.stringForColumn("nodename")
                    rootnode = node
                }
            } else {
                appLog.error("执行SQL:\(sql)  报错信息:\(error)")
            }
        }
        return rootnode
    }
    

    // MARK:- 保存节点
    class func saveNode(user:NodeModel) -> Bool {
        
        return DBManager.shareInstance().executeUpdate({ (db) -> Bool in
            
            let sql = "Replace INTO TB_Node (nodeID, nodename, parentID, node_Level, code_Level, node_type) VALUES (?, ?, ?, ?, ?, ?)"
            
            let args = [user.nodeID,
                        DBV(user.nodename),
                        user.parentID,
                        DBV(user.node_Level),
                        DBV(user.code_Level),
                        DBV(user.node_type)]

            if !db.executeUpdate(sql, withArgumentsInArray: args) {
                appLog.error("执行SQL:\(sql) 参数:\(args) 报错信息:\(db.lastErrorMessage()) \(db.lastError().description)")
                return false
            }
            return true
        })
    }
   
    // MARK:- 获得某节点下所有直接子节点
    class func getNode(by nodID: String) -> [NodeModel]{
        let sql = "select * from TB_Node where parentID = ? "
        let arg = [nodID]
        var nodes = [NodeModel]()
        DBManager.shareInstance().executeQuery(sql, args: arg) { (resultSet, error) -> Void in
            if error == nil {
                while resultSet!.next() {
                    let node = NodeModel()
                        node.nodeID = resultSet?.stringForColumn("nodeID")
                        node.parentID = resultSet?.stringForColumn("parentID")
                        node.node_Level = resultSet?.stringForColumn("node_Level")
                        node.code_Level = resultSet?.stringForColumn("code_Level")
                        node.node_type = resultSet?.stringForColumn("node_type")
                        node.nodename = resultSet?.stringForColumn("nodename")
                        nodes.append(node)
                }
            } else {
                appLog.error("执行SQL:\(sql)  报错信息:\(error)")
            }
        }
        return nodes
    }
    
    // MARK:-     // 删除
    // MARK:- 删除节点
    class func deleteFold(currnetNodes: [NodeModel]){

        for node in currnetNodes {
            let sql = "delete from TB_Node where nodeID = ?"
            let args = [node.nodeID!]
            DBManager.shareInstance().executeUpdate(sql, withArgumentsInArray: args)
            
            let subNodes = self.getNode(by: node.nodeID!)
            if subNodes.count != 0 {
                self.deleteFold(subNodes)
            }
        }
    }

    // MARK:-   //  移动
    // MARK:- 将目标节点父节点改为 其他节点
    class func moveNodes(originNodes : [NodeModel], targetNode: NodeModel){
        for node in originNodes {
            let sql = "update TB_Node SET parentID = ? WHERE nodeID = ?"
            let args = [targetNode.nodeID!, node.nodeID!]
            DBManager.shareInstance().executeUpdate(sql, withArgumentsInArray: args)
        }
    }
    
    // MARK:- // 复制
    // MARK:-   复制
    class func copyNode(originNodes : [NodeModel], toNode: NodeModel){
        // 遍历处理节点
        for node in originNodes {
            
            // 复制节点
            let newNode = node.copyNode()
                newNode.nodeID = "\(NSDate.timeStamp())"
                newNode.parentID = toNode.nodeID
            self.saveNode(newNode) // 保存节点
            
            // 递归
            let subNodes = self.getNode(by: node.nodeID!)
            print(node.nodeID)
            if subNodes.count != 0 {
                self.copyNode(subNodes, toNode: newNode)
            }
        }
    }

//  MARK:-  将文件组成新文件夹
    class func addNewFolds(originNodes : [NodeModel]){
        let newNode = NodeModel(data: [
            "nodeID" : "\(NSDate.timeStamp())",
            "nodename": "Temp",
            "parentID": originNodes.first!.parentID!,
            "node_type": NodeType.fold.rawValue
            ])
        self.saveNode(newNode)
        
        for n in originNodes {
            let nN = n.copyNode()
            nN.parentID = newNode.nodeID
            self.saveNode(nN)
        }
    }
    
}