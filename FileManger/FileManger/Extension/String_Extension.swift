//
//  String_Extension.swift

//
//  Created by chdo on 3/26/15.
//  Copyright (c) 2015 Louding. All rights reserved.
//

import UIKit


extension String {
    
//    var md5: String! {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen)
//        CC_MD5(str!, strLen, result)
//        let hash = NSMutableString()
//        for i in 0..<digestLen {
//            hash.appendFormat("%02x", result[i])
//        }
//        result.dealloc(digestLen)
//        return String(format: hash as String)
//    }
    
    
    var UTF8length : Int {
        var len = 0
        for i in self.characters {
            if String(i).lengthOfBytesUsingEncoding(NSUTF8StringEncoding) == 3 {
                len += 2
            }else{  // 1 , 4
                len += 1
            }
        }
        return len
    }
    
    func subStringAt(indx: Int) -> String{
        var str = ""
        for i in self.characters {
            let tem = str + String(i)
            if tem.UTF8length >= indx {
                break
            } else {
                str = str + String(i)
            }
        }
        return str
    }
    
    subscript (i: Int) -> String{
        return String(Array(self.characters)[i])
    }
    
    subscript (r: Range<Int>) -> String{
        let start = startIndex.advancedBy(r.startIndex)
        let end = startIndex.advancedBy(r.endIndex)
        return substringWithRange(Range(start..<end))
    }
    
    func addPathCompent(path: String) -> String{
        return self.stringByAppendingString("/" + path)
    }
    
    func size(byfont size: CGFloat) -> CGSize{
        return (self as NSString).sizeWithAttributes([NSFontAttributeName: UIFont.systemFontOfSize(size)])
    }

}
