//
//  UIImage_Extension.swift

//
//  Created by chdo on 4/28/15.
//  Copyright (c) 2015 Louding. All rights reserved.
//

import UIKit
import AVFoundation

extension UIImage {

    class func imageWithColor(color:UIColor,size:CGSize) -> UIImage
    {
        let rect = CGRectMake(0, 0, size.width, size.height);
        
        // 画图开始
        UIGraphicsBeginImageContext(size);
        // 获取图形设备上下文
        let context = UIGraphicsGetCurrentContext();
        // 设置填充颜色
        CGContextSetFillColorWithColor(context, color.CGColor);
        // 用所设置的填充颜色填充
        CGContextFillRect(context, rect);
        // 得到图片
        let image = UIGraphicsGetImageFromCurrentImageContext();
        // 画图结束，解释资源
        UIGraphicsEndImageContext();
        return image;
    }
    
    // 调整UIimage大小
    func resizeToSize(size: CGSize!) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        self.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    
    // MARK:- 切割中间部分
    func cropToCenter() -> UIImage? {
        
        let originSize = self.size
        let bigSide = max(originSize.width, originSize.height)
        let smallSide = min(originSize.width, originSize.height)
        var x : CGFloat!
        var y : CGFloat!
        if bigSide == originSize.height{
            x = 0
            y = (bigSide - smallSide) / 2
        }else{
            x = (bigSide - smallSide) / 2
            y = 0
        }
        let rec = CGRectMake(y, x, smallSide, smallSide)
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, rec)
        let result = UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        return result
    }
//    
//    // MARK:- 截取中上间段
//    func cropMidUp() -> UIImage?{
//        let originSize = self.size
//        let bigSide = max(originSize.width, originSize.height)
//        let smallSide = min(originSize.width, originSize.height)
//        let screenRatio = Global.getScreenWidth() / Global.getScreenHeight()
//        let picW = bigSide * screenRatio
//        let x = (smallSide - picW) / 2
//        let y = (45 / Global.getScreenHeight()) * bigSide
//        let rec = CGRectMake(y, x, picW, picW)
//        let imageRef = CGImageCreateWithImageInRect(self.CGImage, rec)
//        let result = UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
//        return result
//    }
    
    // Crops an input image (self) to a specified rect
    func cropToRect(rect: CGRect!) -> UIImage? {
        // Correct rect size based on the device screen scale
        let scaledRect = CGRectMake(rect.origin.x * self.scale, rect.origin.y * self.scale, rect.size.width * self.scale, rect.size.height * self.scale);
        // New CGImage reference based on the input image (self) and the specified rect
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, scaledRect);
        // Gets an UIImage from the CGImage
        let result = UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
        // Returns the final image, or NULL on error
        return result;
    }

    // MARK:- 截屏
    static func screenShot() ->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(UIScreen.mainScreen().bounds.size, false, UIScreen.mainScreen().scale)
        UIApplication.sharedApplication().keyWindow!.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let ima = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return ima
    }
    
    // MARK:- 截图
    func cutImageInrect(rect: CGRect) -> UIImage{
        let rec = CGRectMake(rect.origin.y, rect.origin.x, rect.height, rect.height)
        let imageRef = CGImageCreateWithImageInRect(self.CGImage, rec)
        return UIImage(CGImage: imageRef!, scale: self.scale, orientation: self.imageOrientation)
    }
    
    static func cutImageInrect(ima: UIImage, rect: CGRect) -> UIImage{
        let rec = CGRectMake(rect.origin.y, rect.origin.x, rect.height, rect.height)
        let imageRef = CGImageCreateWithImageInRect(ima.CGImage, rec)
        return UIImage(CGImage: imageRef!, scale: ima.scale, orientation: ima.imageOrientation)
    }
    
    func compressTo(lenght: Int) -> NSData {
        let data = UIImageJPEGRepresentation(self, 1)
        let finnal: NSData?
        if data?.length > lenght {
            finnal = UIImageJPEGRepresentation(self, CGFloat(lenght) / CGFloat((data?.length)!))
        }else{
            finnal = data
        }
        return finnal!
    }
    
}
