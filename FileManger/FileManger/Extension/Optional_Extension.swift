//
//  Optional_Extension.swift

//
//  Created by chdo on 3/30/15.
//  Copyright (c) 2015 Louding. All rights reserved.
//

import Foundation

extension Optional {
    
    func defaultValue(defaultValue: Wrapped) -> Wrapped {
        switch(self) {
        case .None:
            return defaultValue
        case .Some(let value):
            return value
        }
    }
    
}