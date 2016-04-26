//
//  FoldCell.swift
//  FileManger
//
//  Created by chdo on 16/4/14.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit


class FoldCell: UICollectionViewCell {
    
    var isCellSelected = false
    
    var checKBox: UIButton!

    var backView: UIView!
    var iconImage: UIImageView!
    var foldLabel: UIImageView!
    var indicator: UIImageView!
    
    
//    var backLayer: CAGradientLayer!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.clipsToBounds = true
        
//        backLayer = CAGradientLayer()
//        backLayer.frame = bounds
//        layer.addSublayer(backLayer)
        
//        backLayer.colors
        
        
        // 背景色
        backView = UIView(frame: bounds)
        backView.backgroundColor = UIColor.clearColor()
        addSubview(backView)
        
        // 文件夹图标
        iconImage = UIImageView(image: UIImage(named: "folder"))
        iconImage.contentMode = .ScaleAspectFit
        iconImage.frame = CGRectMake(0.1 * frame.width,
                                     0.25 * frame.height,
                                     0.2 * frame.width ,
                                     0.5 * frame.height)
        backView.addSubview(iconImage)
        
        // 文件夹名称
        foldLabel = UIImageView(image: UIImage(named: "2016Chanel春季"))
        foldLabel.contentMode = .ScaleAspectFit
        foldLabel.frame = CGRectMake(0.36 * frame.width,
                                     0.25 * frame.height,
                                     0.4 * frame.width,
                                     0.5 * frame.height)
        backView.addSubview(foldLabel)


        // 右边箭头
        indicator = UIImageView(image: UIImage(named: "more"))
        indicator.contentMode = .ScaleAspectFit
        indicator.frame = CGRectMake(0.85 * frame.width,
                                     0.35 * frame.height,
                                     0.07 * frame.width,
                                     0.3 * frame.height)
        backView.addSubview(indicator)

        // 多选框
        checKBox = UIButton()
        checKBox.frame = CGRectMake(-0.1 * frame.width,
                                    0,
                                    0.15 * frame.width,
                                    frame.height)
        checKBox.setImage(UIImage(named: "Oval 31"), forState: UIControlState.Normal)
        checKBox.addTarget(self, action: #selector(FoldCell.clickCheckbox), forControlEvents: UIControlEvents.TouchUpInside)
        backView.addSubview(checKBox)
        
        checKBox.alpha = 0
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(FoldCell.toggleEdit(_:)), name: EditToggleNotification, object: nil)
        
        
    }
    
    func toggleEdit(noti: NSNotification) {
        
        let selecting = noti.object as! Bool
        
        if selecting {
            
            UIView.animateWithDuration(0.1, animations: { 
                self.indicator.alpha =  0
            })
            
            UIView.animateWithDuration(0.2, animations: {
                self.backView.frame = CGRectMake(self.frame.width * 0.15, 0, self.frame.width, self.frame.height)
            }) { (_) in
                
            }
            UIView.animateWithDuration(0.4, delay: 0.15, options: [], animations: {
                self.checKBox.alpha = 1
            }) { (_) in
                self.bringSubviewToFront(self.checKBox)
            }
            
        } else {
            UIView.animateWithDuration(0.2, animations: {
                self.checKBox.alpha = 0
            }) { (_) in
                self.checKBox.setImage(UIImage(named: "Oval 31"), forState: UIControlState.Normal)
            }
            UIView.animateWithDuration(0.4, delay: 0.15, options: [], animations: {
                self.indicator.alpha = 1
                self.backView.frame = self.bounds
            }, completion: nil)
            
            isCellSelected = false
        }
    }
    
    func clickCheckbox(){
        isCellSelected = !isCellSelected
        checKBox.setImage(UIImage(named: !isCellSelected ? "Oval 31" : "Group"), forState: UIControlState.Normal)
    }
    
    func checkToSelectingState() {
        
        
        checKBox.setImage(UIImage(named: !isCellSelected ? "Oval 31" : "Group"), forState: UIControlState.Normal)
        UIView.animateWithDuration(0.1, animations: {
            self.indicator.alpha =  0
        })
        
        UIView.animateWithDuration(0.2, animations: {
            self.backView.frame = CGRectMake(self.frame.width * 0.15, 0, self.frame.width, self.frame.height)
        }) { (_) in
            
        }
        UIView.animateWithDuration(0.4, delay: 0.15, options: [], animations: {
            self.checKBox.alpha = 1
        }) { (_) in
            self.bringSubviewToFront(self.checKBox)
        }
    }
    
    func checkState(bol: Bool) {
        checKBox.setImage(UIImage(named: !bol ? "Oval 31" : "Group"), forState: UIControlState.Normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
