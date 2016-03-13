//
//  DirectoryUtils.swift
//  Yilicai
//
//  Created by Apple5 on 15/1/20.
//  Copyright (c) 2015年 Louding. All rights reserved.
//

import UIKit

class DirectoryUtils: NSObject {
   
    class var documentsDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
    
    class var cacheDirectory: NSURL {
        let urls = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask)
        return urls[urls.endIndex-1] as NSURL
    }
    
    
    
    // MARK:- 获取 Document路径
    class func getDocumentPath() ->String{
        return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String)
    }
    
//    class func getDocumetSubPath(path: String) ->String{
//        return DirectoryUtils.getDocumentPath().addPathCompent(path)
//    }
//    
//    // MARK:- ImageFile
//    
//    class func getImagePath() -> String {
//        return DirectoryUtils.getDocumentPath().addPathCompent("images")
//    }
//    
//    class func getCurrentImagePath( productCreatTime: String ) -> String {
//        return DirectoryUtils.getImagePath().addPathCompent(productCreatTime)
//    }
//    
//    // MARK:- UserFile
//    class func getUsersPath() -> String {
//        return DirectoryUtils.getDocumentPath().addPathCompent("users")
//    }
//    
//    class func getCurrentUserPath() -> String{
//        return DirectoryUtils.getUsersPath().addPathCompent(Global.getCurrentUserId())
//    }
    
    
    // MARK:- 获取 DataPackage路径
//    class func getDataPackagePath() ->String{
//        return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as String).stringByAppendingPathComponent("DataPackage")
//    }
//    
//    // MARK:- 获取当前 用户 文件夹路径
//    class func getUserDocumentPath() ->String{
//        return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String).stringByAppendingPathComponent("data" + "\(Global.getCurrentUserId())")
//    }
//    
//    //MARK:- 获取帖子图片缓存路径
//    class func getUserPostCachePath() ->String{
//        return (NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0] as! String).stringByAppendingPathComponent("postCache" + "\(Global.getCurrentUserId())")
//    }
}
