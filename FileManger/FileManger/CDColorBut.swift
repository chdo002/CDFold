//
//  CDColorBut.swift
//  FileManger
//
//  Created by chdo on 16/4/15.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

class CDColorBut: UIButton {

    var checkMark: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        checkMark = UIImageView(image: UIImage(named: "check"))
        checkMark.contentMode = .ScaleAspectFit
        checkMark.hidden = true
        addSubview(checkMark)
        checkMark.snp_makeConstraints { (make) in
            make.size.equalTo(self)
            make.center.equalTo(self)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func showCheck(willShow: Bool) {
        checkMark.hidden = !willShow
    }

}
