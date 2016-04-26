//
//  CDToolBar.swift
//  FileManger
//
//  Created by chdo on 16/4/14.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit
let toolFoldColors = [0x3EA8EA, 0x8463CF, 0xFF6400, 0x30B10D]

class CDToolBar: UIView {

    var editButs = [UIButton]()
    
    var willShowFoldColor = false
    
    var colorBar : UIView!
    var colorButs = [CDColorBut]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.whiteColor()
        self.alpha = 0
        colorBar = UIView(frame: CGRectMake(0, 0, frame.width, frame.height / 2))
        colorBar.backgroundColor = UIColor.whiteColor()
        addSubview(colorBar)
        
        // 四种颜色  
        let itemW = frame.width / CGFloat(toolFoldColors.count)

        for en in toolFoldColors.enumerate() {
            let but = CDColorBut(frame: CGRectMake(CGFloat(en.0) * itemW + itemW * 0.15, colorBar.frame.height * 0.4, itemW * 0.7, colorBar.frame.height * 0.6))
                but.layer.cornerRadius = 5
                but.backgroundColor = UIColor.colorFromHexRGB(en.1)
                but.alpha = 0
                but.addTarget(self, action: #selector(CDToolBar.clickDownColorFold(_:)), forControlEvents: UIControlEvents.TouchDown)
                but.addTarget(self, action: #selector(CDToolBar.clickUpColorFold(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                but.userInteractionEnabled = false
                but.tag = en.0
                colorBar.addSubview(but)
                colorButs.append(but)
        }
    }
    
    func addButs(names: [String]) {
        
        let itemW = frame.width / CGFloat(names.count)
        
        for na in names.enumerate() {
            let but = UIButton(frame: CGRectMake(CGFloat(na.0) * itemW, frame.height / 2 , itemW, frame.height / 2))
                but.setImage(UIImage(named: na.1), forState: UIControlState.Normal)
                but.tag = na.0
                but.addTarget(self, action: #selector(CDToolBar.clickFoounc(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                addSubview(but)
            
                if na.0 != 0 {
                    but.enabled = false
                    editButs.append(but)
                }
        }
    }
    
    
    func showToolBar(willShow: Bool, complete: ()->Void ) {
        
        willShowFoldColor = willShow
        
        let itemW = frame.width / 4
        
        if willShow { // 显示工具栏
            
            complete()
            UIView.animateWithDuration(0.4, animations: {
                self.alpha = 1
                }, completion: { (_) in
            })
            
            for en in colorButs.enumerate() {
                UIView.animateWithDuration(0.6, delay: 0.1 * Double(en.0) , options: [], animations: {
                    en.1.frame = CGRectMake(CGFloat(en.0) * itemW + itemW * 0.15, self.colorBar.frame.height * 0.2, itemW * 0.7, self.colorBar.frame.height * 0.6)
                    en.1.alpha = 1
                    }, completion: { (_) in
                        
                })
            }
        } else {    // 不显示工具栏
            
            complete()
            UIView.animateKeyframesWithDuration(0.4, delay: 0.25, options: [], animations: {
                self.alpha = 0
                }, completion: { (_) in
            })
            
            for en in colorButs.enumerate() {
                UIView.animateWithDuration(0.2, delay: 0.1 * Double(en.0) , options: [], animations: {
                    en.1.frame = CGRectMake(CGFloat(en.0) * itemW + itemW * 0.15, self.colorBar.frame.height * 0.4, itemW * 0.7, self.colorBar.frame.height * 0.6)
                    en.1.alpha = 0
                    }, completion: { (_) in
   
                })
            }
            
            for en in editButs.enumerate() {
                en.1.enabled = en.0 == 0
            }
        }
    }
    
    func itemSelectionObserver(didSelected indexes: [NSIndexPath]) {
                
        if indexes.count == 0 {
            for b in editButs {
                b.enabled = false
            }
            
            for b in colorButs {
                b.userInteractionEnabled = false
            }
            
            
        } else if indexes.count == 1 {
            for b in editButs {
                b.enabled = true
            }
            
            for b in colorButs {
                b.userInteractionEnabled = true
            }
            
        } else {
            
            for en in editButs.enumerate() {
                if en.0 == 0 {
                    en.1.enabled = false
                } else {
                    en.1.enabled = true
                }
            }
            
            for b in colorButs {
                b.userInteractionEnabled = false
            }
        }
    
    }
    
    func clickDownColorFold(but: UIButton) {
        
        UIView.animateWithDuration(0.1) { 
            but.transform = CGAffineTransformMakeScale(0.8, 0.8)
        }
    }
    
    func clickUpColorFold(but: UIButton)  {
        UIView.animateWithDuration(0.1) {
            but.transform = CGAffineTransformMakeScale(1, 1)
        }
        
        for b in colorButs {
            b.showCheck(b == but)
        }
        NSNotificationCenter.defaultCenter().postNotificationName(changeCellColor, object: but.tag)
    }
    
    func clickFoounc(but: UIButton) {
        
        switch but.tag {
            
        case 0:
            NSNotificationCenter.defaultCenter().postNotificationName(creatNewFold, object: nil)
        case 4:
            NSNotificationCenter.defaultCenter().postNotificationName(removeItems, object: nil)
        default:
            return
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}

