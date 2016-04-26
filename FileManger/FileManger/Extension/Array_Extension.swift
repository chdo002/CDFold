//
//  Array_Extension.swift

//
//  Created by chdo on 3/26/15.
//  Copyright (c) 2015 Louding. All rights reserved.
//

import Foundation

//http://vperi.com/2014/06/04/slicing-arrays-in-swift/

extension Array {
    func slice(args: Int...) -> Array {
        var s = args[0]
        var e = self.count - 1
        if args.count > 1 { e = args[1] }
        
        if e < 0 {
            e += self.count
        }
        
        if s < 0 {
            s += self.count
        }
        
        let count = (s < e ? e-s : s-e)+1
        let inc = s < e ? 1 : -1
        var ret = Array()
        
        var idx = s
//        for var i=0;i<count;i++  {
//            
//        }
        for _ in 0...count {
            ret.append(self[idx])
            idx += inc
        }
        return ret
    }
}


/**
*  数组相减

*/
infix operator <-> {}

func <-> (left: [String], right: [String]) -> [String] {
    var reslt = left
    for num in right {
        for i in 0...reslt.count - 1 {
            if reslt[i] == num {
                reslt.removeAtIndex(i)
                break
            }
        }
    }
    return reslt
}

// [1,2,3,4,5]  -> [4,5,1,2,3]

func reSetArry<T>(arr:[T], byRange index: Int) -> [T]{
    let frontArr = Array(arr[arr.count  - index...arr.count - 1])
    let leftArr  = Array(arr[0 ... arr.count - 1 - index])
    return frontArr + leftArr
}



