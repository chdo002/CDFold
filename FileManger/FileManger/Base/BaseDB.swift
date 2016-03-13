//
//  BaseDB.swift
//  EZY3D
//
//  Created by chdo on 15/9/24.
//  Copyright © 2015年 YingWei. All rights reserved.
//

import UIKit

func V(oValue:AnyObject?) -> AnyObject!
{
    return oValue == nil ? NSNull() : oValue!
}

protocol IBaseDao
{
    static func createTable(db:FMDatabase) -> Bool
}

class BaseDao: NSObject {
    
    static func DBV(oValue:AnyObject?) -> AnyObject!
    {
        return oValue == nil ? NSNull() : oValue!
    }
    
}
