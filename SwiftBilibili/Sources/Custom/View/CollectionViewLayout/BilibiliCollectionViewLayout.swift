//
//  BilibiliCollectionViewLayout.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/18.
//  Copyright © 2018年 罗文. All rights reserved.
//  处理cell间距为0仍有间隙的问题

import UIKit

final class BilibiliCollectionViewLayout: UICollectionViewFlowLayout {

    var maxInteritemSpacing: CGFloat = 0
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
       guard let superAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
        
       var attributes = NSArray(array: superAttributes, copyItems: true) as! [UICollectionViewLayoutAttributes]
        
       if attributes.count < 2 { return attributes }
        
       for i in 1..<attributes.count {
           let currentLayoutAttributes = attributes[i]
           let prevLayoutAttributes = attributes[i-1]
           let origin = prevLayoutAttributes.frame.maxX
           if origin + maxInteritemSpacing + currentLayoutAttributes.frame.size.width <= self.collectionViewContentSize.width {
            
              var frame = currentLayoutAttributes.frame
              frame.origin.x = origin + maxInteritemSpacing
              currentLayoutAttributes.frame = frame
           }
       }
       return attributes
    }
}
