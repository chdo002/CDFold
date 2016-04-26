//
//  NSDate.swift

//
//  Created by chdo on 15/5/15.
//  Copyright (c) 2015年 楼顶. All rights reserved.
//

import UIKit

extension NSDate {
   
    func getString() -> String{
        let forma = NSDateFormatter()
            forma.dateFormat = "yyyy-MM-dd"
        return forma.stringFromDate(self)
    }
}
