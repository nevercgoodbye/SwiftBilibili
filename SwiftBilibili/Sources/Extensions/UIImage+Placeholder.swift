//
//  UIImage+Placeholder.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SwiftyImage

extension UIImage {
    
   class func placeholderImage(bgColor:UIColor = .db_gray,bgSize:CGSize) -> UIImage? {
    
       if bgSize == .zero {
          return nil
       }
    
       let bgImage = UIImage.size(bgSize).color(bgColor).image
       let centerImage = Image.Home.default_img!
       let placeholderImage = bgImage + centerImage
       return placeholderImage
   }
   
   class func resizeImage(image:UIImage?,newSize:CGSize) -> UIImage? {
        
        guard let image = image else {
            return nil
        }
        
        UIGraphicsBeginImageContext(newSize)
        image.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    
}
