//
//  LXHFlowLayout.swift
//  LXHFlowLayout
//
//  Created by JinShiJinSheng on 2018/1/6.
//  Copyright © 2018年 JinShiJinSheng. All rights reserved.
//

import UIKit

class LXHFlowLayout: UICollectionViewFlowLayout {
    private lazy var attrs:[UICollectionViewLayoutAttributes] = [UICollectionViewLayoutAttributes]()
    
    var numOfItemsInRow:Int = 7
    var numOfItemsInColumn:Int = 3
    
    init(numOfItemsInRow:Int,numOfItemsInColumn:Int) {
        super.init()
        self.numOfItemsInRow = numOfItemsInRow
        self.numOfItemsInColumn = numOfItemsInColumn
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepare() {
        super.prepare()
        
        attrs.removeAll()
        
        self.scrollDirection = UICollectionViewScrollDirection.horizontal
        let numOfItemsInContent:Int = numOfItemsInRow * numOfItemsInColumn
        let width:CGFloat = collectionView!.frame.size.width/CGFloat(numOfItemsInRow)
        let height = width
        collectionView?.isPagingEnabled = true
        let offY = (collectionView!.bounds.height - CGFloat(numOfItemsInColumn)*width)*0.49
        collectionView?.contentInset = UIEdgeInsetsMake(offY, 0, offY, 0)
        self.sectionInset = UIEdgeInsetsMake(offY, 0, offY, 0)
        
        let sections = collectionView!.numberOfSections

        var maxX:CGFloat = 0.0
        
        for section in 0..<sections{
            
            let count = collectionView!.numberOfItems(inSection:section)
            
            var oY:CFloat = 0.0
            
            var offX:CGFloat = 0
            
            for item in 0..<count {
                
                let oX:CGFloat = width * CGFloat(item%numOfItemsInRow) + maxX + offX

                let indexPath = IndexPath.init(item: item, section: section)
                let attr = UICollectionViewLayoutAttributes.init(forCellWith: indexPath)
                if item%numOfItemsInRow == 0 && (item/numOfItemsInRow)%numOfItemsInColumn < numOfItemsInColumn{
                    oY = CFloat(width * CGFloat((item/numOfItemsInRow)%numOfItemsInColumn))

                }else if (item%numOfItemsInRow == 0) && (((item/numOfItemsInRow)%numOfItemsInColumn) == 0){
                    oY = 0.0
                }else{
                    oY = Float(CGFloat((item/numOfItemsInRow)%numOfItemsInColumn) * height)
                }
            
                attr.frame = CGRect.init(x: oX, y: CGFloat(oY), width: width, height: height)

                attrs.append(attr)
                if item == (count - 1){
                    maxX = CGFloat(attr.frame.maxX)
                }
                if (item+1)%numOfItemsInContent == 0{
                    
                    offX = CGFloat((item+1)/numOfItemsInContent * numOfItemsInRow) * width
                }
            }
        }
    }
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
       
        return attrs
    }
    override var collectionViewContentSize: CGSize{
        let width = collectionView!.frame.size.width/CGFloat(numOfItemsInRow)
        return CGSize.init(width:width * CGFloat(attrs.count)/CGFloat(numOfItemsInColumn) , height: width * CGFloat(numOfItemsInColumn))
//        return CGSize.init(width: width * 7 , height: width * CGFloat(attrs.count/7))
    }
}
