//
//  FileCell.swift
//  FileManger
//
//  Created by chdo on 16/4/14.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

class FileCell: UICollectionViewCell {
    
    var itemIma: UIImageView!  // 背景图片
    var itemLabel: UITextView! // item标题
    var checKBox: UIButton!    // 复选框
    
    var isSelecting = false     // cell 是否在编辑态
    var isCellSelected = false  // cell 是否被选中
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.clipsToBounds = true
        backgroundColor = UIColor.whiteColor()
        itemIma = UIImageView(image: UIImage(named: "textback"))
        itemIma.contentMode = .ScaleAspectFill
        itemIma.frame = bounds
        addSubview(itemIma)
        
        
        itemLabel = UITextView()
        itemLabel.textColor = UIColor.whiteColor()
        itemLabel.font = UIFont.winnie(13)
        itemLabel.textAlignment = .Left
        itemLabel.backgroundColor = UIColor.clearColor()
        itemLabel.userInteractionEnabled = false
        itemLabel.frame = CGRectMake(20, 15, frame.width - 20, frame.height - 20)
        addSubview(itemLabel)
        
        // 多选框
        checKBox = UIButton()
        checKBox.setImage(UIImage(named: "Oval 31"), forState: UIControlState.Normal)
        checKBox.addTarget(self, action: #selector(FileCell.clickCheckbox), forControlEvents: UIControlEvents.TouchUpInside)
        checKBox.frame = CGRectMake(0, 15, 0.2 * frame.height, 0.2 * frame.height)
        addSubview(checKBox)
        checKBox.alpha = 0
    
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.toggleEdit(_:)), name: EditToggleNotification, object: nil)
    }

    func toggleEdit(noti: NSNotification) {
        
        isSelecting = noti.object as! Bool
        
        
        if isSelecting {
            
            UIView.animateWithDuration(0.2, animations: {
                self.itemLabel.frame = CGRectMake(40, 15, self.frame.width - 40 , self.frame.height - 20)
            }) { (_) in
                
            }
            UIView.animateWithDuration(0.4, delay: 0.15, options: [], animations: {
                self.checKBox.alpha = 1
                self.checKBox.frame = CGRectMake(10, 15, 0.2 * self.frame.width, 0.2 * self.frame.width)
                }, completion: { (_) in
                    
            })
        } else {
            
            UIView.animateWithDuration(0.2, animations: {
                self.checKBox.alpha = 0
                self.checKBox.frame = CGRectMake(0, 15, 0.2 * self.frame.width, 0.2 * self.frame.width)
            }) { (_) in
                self.checKBox.setImage(UIImage(named: "Oval 31"), forState: UIControlState.Normal)
            }
            
            UIView.animateWithDuration(0.4, delay: 0.15, options: [], animations: {
                self.itemLabel.frame = CGRectMake(20, 15, self.frame.width - 20 , self.frame.height - 20)
                }, completion: nil)
            self.isCellSelected = false
        }
    }
    
    func clickCheckbox() {
        isCellSelected = !isCellSelected
        checKBox.setImage(UIImage(named: !isCellSelected ? "Oval 31" : "Group"), forState: UIControlState.Normal)
    }
    
    func checkToSelectingState() {
        
        UIView.animateWithDuration(0.2, animations: {
            self.itemLabel.frame = CGRectMake(40, 15, self.frame.width - 40 , self.frame.height - 20)
        }) { (_) in
            
        }
        UIView.animateWithDuration(0.4, delay: 0.15, options: [], animations: {
            self.checKBox.alpha = 1
            self.checKBox.frame = CGRectMake(10, 15, 0.2 * self.frame.width, 0.2 * self.frame.width)
            }, completion: { (_) in
                
        })
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
    }
}
