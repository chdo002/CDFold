//
//  DBManger.swift
//  FileManger
//
//  Created by chdo on 15/9/24.
//  Copyright © 2015年 YingWei. All rights reserved.
//


import UIKit

let appLog = XCGLogger.defaultInstance()
//数据库路径
func databasePath()->String
{
    return DirectoryUtils.documentsDirectory.URLByAppendingPathComponent("ezy.db").absoluteString
}

//单利类 操作数据库是线程安全的
class DBManager: NSObject {
    
    var queue: FMDatabaseQueue!
    var writeQueueLock: NSRecursiveLock!
    
    class func shareInstance()->DBManager{
        struct DBManagerSingleton{
            static var predicate:dispatch_once_t = 0
            static var instance:DBManager? = nil
        }
        dispatch_once(&DBManagerSingleton.predicate,{
            DBManagerSingleton.instance = DBManager()
            DBManagerSingleton.instance!.queue = FMDatabaseQueue(path: databasePath())
            DBManagerSingleton.instance!.writeQueueLock = NSRecursiveLock()
            }
        )
        return DBManagerSingleton.instance!
    }
    
    /**
    初始化数据库，创建表
    */
    func initDB()
    {
        let hasBeenInitialized = NSUserDefaults.standardUserDefaults().boolForKey("DBIsInitialized")
        
        guard !hasBeenInitialized else {
            return
        }
        
        // 设置 XCGLogger
        let logPath : NSURL = DirectoryUtils.cacheDirectory.URLByAppendingPathComponent("Log.txt")
        appLog.setup(.Debug, showLogLevel: true, showFileNames: true, showLineNumbers: true, writeToFile: logPath)

        writeQueueLock.lock()
        queue.inTransaction { (db, rollback) -> Void in
            appLog.debug("数据库初始化开始\(databasePath())")
            //创建用户表
            if !Node.createTable(db) {
                rollback.initialize(true)
                return
            }
            //所有数据库表创建成功，则标记数据库初始化成功
            NSUserDefaults.standardUserDefaults().setBool(true, forKey: "DBIsInitialized")
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        
        writeQueueLock.unlock()
        
        appLog.debug("数据库初始化结束")
        
        Node.saveNode(NodeModel(data: [
            "nodeID": "123123",
            "nodename": "根目录",
            "parentID": "0",
            "node_type": "1"
            ]))
    }
    
    
    /**
    
    数据库更新操作
    
    :param: sql :插入，更新，删除等操作
    :param: args :后面附带的参数
    
    :returns: 成功或失败
    
    */
    func executeUpdate(sql:String, withArgumentsInArray args:[AnyObject]) -> Bool
    {
        var excuteResult = false
        
        writeQueueLock.lock()
        
        queue.inDatabase { (db) -> Void in
            
            excuteResult = db.executeUpdate(sql, withArgumentsInArray: args)
            
            if !excuteResult
            {
                appLog.error("执行SQL:\(sql) 参数:\(args) 报错信息:\(db.lastErrorMessage()) \(db.lastError().description)")
            }
        }
        writeQueueLock.unlock()
        
        return excuteResult
    }
    
    
    func executeUpdate(sql:String, withParameterDictionary args:[NSObject : AnyObject]) -> Bool
    {
        var excuteResult = false
        
        writeQueueLock.lock()
        
        queue.inDatabase { (db) -> Void in
            
            excuteResult = db.executeUpdate(sql, withParameterDictionary: args)
            
            if !excuteResult
            {
                appLog.error("执行SQL:\(sql) 参数:\(args) 报错信息:\(db.lastErrorMessage()) \(db.lastError().description)")
            }
        }
        writeQueueLock.unlock()
        
        return excuteResult
    }
    
    func executeUpdate(inTransaction :(db:FMDatabase) -> Bool) -> Bool
    {
        var executeSuccess = false
        
        writeQueueLock.lock()
        queue.inTransaction { (db, rollback) -> Void in
            
            executeSuccess = inTransaction(db: db)
            
            if !executeSuccess
            {
                rollback.initialize(true)
            }
        }
        writeQueueLock.unlock()
        
        return executeSuccess
    }
    
    
    func executeQuery(sql:String!, args:NSArray!,onQueried:(resultSet:FMResultSet?,error:NSError?)->Void)
    {
        
        writeQueueLock.lock()
        
        queue.inDatabase { (db) -> Void in
            
            let resultSet = db.executeQuery(sql, withArgumentsInArray: args as [AnyObject])
            if resultSet == nil
            {
                appLog.error("执行SQL:\(sql) 参数:\(args) 报错信息:\(db.lastErrorMessage())")
                onQueried(resultSet: nil, error:db.lastError())
            }else{
                onQueried(resultSet: resultSet,error:nil)
            }
            resultSet.close()
        }
        writeQueueLock.unlock()
    }
    
    func query(sql:String!,onQueried:(resultSet:FMResultSet?,error:NSError?)->Void){
        writeQueueLock.lock()
        
        queue.inDatabase { (db) -> Void in
            
            let resultSet = db.executeQuery(sql, withArgumentsInArray: nil)
            if resultSet == nil
            {
                onQueried(resultSet: nil, error:db.lastError())
            }else{
                onQueried(resultSet: resultSet,error:nil)
            }
            resultSet.close()
        }
        writeQueueLock.unlock()
        
    }
    
    //插入记录 返回最后一条插入记录的ID
    func insert(inTransaction :(db:FMDatabase) -> Bool) -> Int?
    {
        var lastInsertRowId: Int?
        
        writeQueueLock.lock()
        queue.inTransaction { (db, rollback) -> Void in
            
            let executeSuccess = inTransaction(db: db)
            
            if executeSuccess
            {
                lastInsertRowId = Int(db.lastInsertRowId())
            }else{
                rollback.initialize(true)
            }
        }
        writeQueueLock.unlock()
        
        return lastInsertRowId
    }
    
    func executeQuery(inTransaction :(db:FMDatabase) -> Bool) -> Bool
    {
        var executeSuccess = false
        
        writeQueueLock.lock()
        queue.inTransaction { (db, rollback) -> Void in
            
            executeSuccess = inTransaction(db: db)
            
            if !executeSuccess
            {
                rollback.initialize(true)
            }
        }
        writeQueueLock.unlock()
        
        return executeSuccess
    }
    
    static func DBV(oValue:AnyObject?) -> AnyObject!
    {
        return oValue == nil ? NSNull() : oValue!
    }
    
}

