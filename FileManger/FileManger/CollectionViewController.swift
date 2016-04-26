//
//  CollectionViewController.swift
//  FileManger
//
//  Created by chdo on 16/4/13.
//  Copyright © 2016年 yw. All rights reserved.
//

import UIKit

private let reuseFoldCellIdentifier = "Cell1"
private let reuseItemCellIdentifier = "Cell2"

let EditToggleNotification = "EditToggleNotification"

let creatNewFold = "creatNewFold"  // 创建新文件夹
let removeItems = "removeItems"    // 移除对象

let changeCellColor = "changeColor"


class CollectionViewController: UICollectionViewController {

    var isCellSelecting = false {
        didSet {
            if isCellSelecting {
                
            } else {
                
            }
        }
    }
    //, 0x3050BE, 0x0081FF, 0x979163, 0xC3B43D, 0x50BE30
    var foldColors = [0x3EA8EA, 0x8463CF, 0xFF6400, 0x30B10D]
    
    var itemPics = ["Group1", "Group 2", "Group 3", "Group 4","Group1", "Group 2", "Group 3", "Group 4"]
    var itemNames = ["AEROCCINO PLUS Milk Frother", "CERRUTS 88 BIG", "IRK BIKKEMBERGS白色休闲鞋S052", "LANVIN PARIS SLN588","AEROCCINO PLUS Milk Frother", "CERRUTS 88 BIG", "IRK BIKKEMBERGS白色休闲鞋S052", "LANVIN PARIS SLN588"]
    
    var editIndexes = [NSIndexPath]() {
        didSet {
            print(editIndexes.count)
            toolBar.itemSelectionObserver(didSelected: editIndexes)
        }
    }
    
    var toolBar: CDToolBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBarController?.hidesBottomBarWhenPushed = true
        
        self.collectionView?.backgroundColor = UIColor.colorFromHexRGB(0x3D3D3D)
        self.title = "文件夹demo"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Edit"), style: UIBarButtonItemStyle.Done, target: self, action: #selector(CollectionViewController.toggleEdit(_:)))
        collectionView?.registerClass(FoldCell.self, forCellWithReuseIdentifier: reuseFoldCellIdentifier)
        collectionView?.registerClass(FileCell.self, forCellWithReuseIdentifier: reuseItemCellIdentifier)
        
        toolBar = CDToolBar(frame: CGRectMake(0, screenH - 98, screenW, 98))
        toolBar.addButs(["tab_new", "tab_rename", "tab_move", "tab_share", "tab_delete"])
        UIApplication.sharedApplication().keyWindow?.addSubview(toolBar)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.insertFold), name: creatNewFold, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.removeSelectedItems), name: removeItems, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.changeColor(_:)), name: changeCellColor, object: nil)
    }
    
    func toggleEdit(but: UIBarButtonItem)  {

        isCellSelecting = !isCellSelecting
        NSNotificationCenter.defaultCenter().postNotificationName(EditToggleNotification, object: isCellSelecting)
        self.toolBar.showToolBar(isCellSelecting) {
            self.tabBarController?.tabBar.hidden = self.isCellSelecting
        }
        collectionView?.contentInset = UIEdgeInsetsMake(0, 0, isCellSelecting ? 49 : 0, 0)
        
        editIndexes.removeAll()
    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }

    // MARK: UICollectionViewDataSource
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        switch section {
        case 0:
            return foldColors.count
        case 1:
            return itemPics.count
        default:
            return 0
        }
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        var cell: UICollectionViewCell!
        switch indexPath.section {
        case 0:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseFoldCellIdentifier, forIndexPath: indexPath)
            (cell as! FoldCell).backgroundColor = UIColor.colorFromHexRGB(foldColors[indexPath.row])
            (cell as! FoldCell).checkState(editIndexes.contains(indexPath))
        case 1:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseItemCellIdentifier, forIndexPath: indexPath)
            (cell as! FileCell).itemIma.image = UIImage(named: itemPics[indexPath.row])
            (cell as! FileCell).itemLabel.text = itemNames[indexPath.row]
        default:
            cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseItemCellIdentifier, forIndexPath: indexPath)
        }
        return cell
    }
    
    

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        if isCellSelecting {
            switch indexPath.section {
            case 0:
                (collectionView.cellForItemAtIndexPath(indexPath) as! FoldCell).clickCheckbox()
            case 1:
                (collectionView.cellForItemAtIndexPath(indexPath) as! FileCell).clickCheckbox()
            default:
                return
            }
            
            if !editIndexes.contains(indexPath) {
                editIndexes.append(indexPath)
            } else {
                for en in editIndexes.enumerate() {
                    if en.1 == indexPath {
                        editIndexes.removeAtIndex(en.0)
                        break
                    }
                }
            }
            
        } else {
            if indexPath.section == 0 {
                let col = CollectionViewController(collectionViewLayout: CollectFlow())
                self.navigationController?.pushViewController(col, animated: true)
            }
        }
    }
    
    override func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
    {
        if isCellSelecting {
            if  cell is FoldCell {
                 (cell as! FoldCell).checkToSelectingState()
            } else if cell is FileCell {
                (cell as! FileCell).checkToSelectingState()
            }
        } else {
            
            if  cell is FoldCell {
                (cell as! FoldCell).isCellSelected = false
            } else if cell is FileCell {
                (cell as! FileCell).isCellSelected = false
            }
        }
    }
    
//    override func collectionView(collectionView: UICollectionView, didEndDisplayingCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath)
//    {
//        if isCellSelecting {
//            
//            if cell.isKindOfClass(FoldCell.self) {
//                (cell as! FoldCell).checkToSelectingState()
//            } else if cell.isKindOfClass(FileCell.self) {
//                (cell as! FileCell).checkToSelectingState()
//            }
//        }
//    }
    
    // MARK:- *****************************文件夹处理部分*****************************
    // MARK:- 插入新文件夹
    func insertFold() {
        //插入文件夹
        let index = NSIndexPath(forItem: self.collectionView(self.collectionView!, numberOfItemsInSection: 0), inSection: 0)
        self.foldColors.append(0x50BE30)
        self.collectionView?.insertItemsAtIndexPaths([index])
        self.collectionView?.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.CenteredVertically, animated: true)
    }
    
    // MARK: 删除文件夹
    func removeSelectedItems() {
        for indexPath in editIndexes {
            switch indexPath.section {
            case 0:
                foldColors.removeAtIndex(indexPath.row)
            case 1:
                itemPics.removeAtIndex(indexPath.row)
                itemNames.removeAtIndex(indexPath.row)
            default:
                return
            }
        }
        collectionView?.deleteItemsAtIndexPaths(editIndexes)
        editIndexes.removeAll()
    }
    
    func changeColor(noti: NSNotification) {
        let obj = noti.object as! Int
        
        if editIndexes.count == 1 {
            foldColors[editIndexes.last!.row] = toolFoldColors[obj]
            collectionView?.reloadData()
        }
    }
    
}
