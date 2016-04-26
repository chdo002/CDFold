//
//  CollectFlow.swift
//  FileManger
//
//  Created by chdo on 16/4/13.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

let screenW = UIScreen.mainScreen().bounds.width
let screenH = UIScreen.mainScreen().bounds.height

class CollectFlow: UICollectionViewFlowLayout, UICollectionViewDelegateFlowLayout {

    var attributesArray: [UICollectionViewLayoutAttributes]!
    
    var contenSize : CGSize!
    // MARK:- 初始化 或 invalatedlayout 时调用下面三个方法 or more
    override func prepareLayout() {
        super.prepareLayout()

        attributesArray = [UICollectionViewLayoutAttributes]()
        
        let rows: CGFloat = 2  // 每行放置cell 个数
        let itemCount1  = self.collectionView!.numberOfItemsInSection(0)
        for i in 0..<itemCount1 {
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forRow: i, inSection: 0))
                let x = screenW / rows * CGFloat(i % Int(rows))
                let y = 100 * CGFloat(i / Int(rows))
                attributes.frame = CGRectMake(x, y, screenW / rows, 100)
            attributesArray.append(attributes)
        }
        
        let itemCount2  = self.collectionView!.numberOfItemsInSection(1)

        for i in 0..<itemCount2 {
            let attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: NSIndexPath(forRow: i, inSection: 1))
                let x = screenW / rows * CGFloat(i % Int(rows))
                let y = 186 * CGFloat(i / Int(rows)) + 100 * CGFloat(ceilf(Float(CGFloat(itemCount1) / rows)))
                attributes.frame = CGRectMake(x, y, screenW / rows, 186)
            attributesArray.append(attributes)
        }
        let h = 100 * CGFloat(ceilf(Float(CGFloat(itemCount1) / rows))) + 186 * CGFloat(ceilf(Float(CGFloat(itemCount2) / rows)))
        contenSize = CGSizeMake(screenW, h)
    }
    // MARK:- 滚动区域大小
    override func collectionViewContentSize() -> CGSize {
        return contenSize
    }
    
    override func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attributesArray
    }

    // MARK:- Add/Remove items
    var remvingItemIndexPath: NSIndexPath?
    override func prepareForCollectionViewUpdates(updateItems: [UICollectionViewUpdateItem]) {
        super.prepareForCollectionViewUpdates(updateItems)
        for item in updateItems {
            switch item.updateAction {
            case .Delete:
                remvingItemIndexPath = item.indexPathBeforeUpdate
            case .Insert:
                print("Insert")
            case .Move:
                print("Move")
            case .Reload:
                print("Reload")
            default:
                break
            }
        }
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
    {
        let attri = super.finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath)
        if itemIndexPath == remvingItemIndexPath {
            attri?.alpha = 0
            attri?.transform = CGAffineTransformMakeScale(0.3, 0.3)
        }
//        print("finalLayoutAttributesForDisappearingItemAtIndexPath")
        return attri
    }
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes?
    {
        let attri = super.initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath)
//        print("initialLayoutAttributesForAppearingItemAtIndexPath")
        return attri
    }
    
    override func finalizeCollectionViewUpdates() {
        super.finalizeCollectionViewUpdates()
        remvingItemIndexPath = nil
    }
    
    // MARK:- collectView bounds changed 调用下面的方法
    override func prepareForAnimatedBoundsChange(oldBounds: CGRect) {
        
    }
    
    override func finalizeAnimatedBoundsChange() {
        
    }
}
