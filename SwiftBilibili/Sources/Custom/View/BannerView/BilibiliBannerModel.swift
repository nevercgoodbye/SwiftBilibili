//
//  BilibiliBannerModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/8.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

struct BilibiliBannerModel {

    var imageUrl: String
    var title: String
    var link: String
    var isAd: Bool
    
    init(imageUrl:String,
         title:String,
         link:String,
         isAd:Bool) {
        
       self.imageUrl = imageUrl
       self.title = title
       self.link = link
       self.isAd = isAd
    }
    
}
