
//
//  nodeModel.swift
//  FileManger
//
//  Created by chdo on 16/3/11.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

// node_type   0 文件 1 文件夹

protocol NodeCopy {
    func copyNode() -> NodeModel
}

enum NodeType: String {
    case file = "0"
    case fold = "1"
}

let rootNodeID = "111111111"

class NodeModel: NSObject, Deserializable, NodeCopy {
  
    var nodeID: String?    // 节点 and key
    var nodename: String?
    var parentID: String?  // 父节点ID
    
    var node_Level: String?
    var code_Level: String?
    var node_type: String?
    
    required init(data: [String : AnyObject]) {
        
        nodeID      <-- data["nodeID"]
        parentID    <-- data["parentID"]
        nodename    <-- data["nodename"]
        node_Level  <-- data["node_Level"]
        code_Level  <-- data["code_Level"]
        node_type   <-- data["node_type"]
    }
    
    override init() {
        super.init()
    }
    

    func copyNode() -> NodeModel {
        let node = NodeModel()
            node.nodeID = self.nodeID
            node.parentID  = self.parentID
            node.nodename = self.nodename
            node.node_Level = self.node_Level
            node.code_Level = self.code_Level
            node.node_type = self.node_type
        return node
    }
}

