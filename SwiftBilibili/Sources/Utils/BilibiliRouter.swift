//
//  BilibiliRouter.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/18.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

enum BilibiliPushType {
    case recommend_rank
    case live_beauty
    case live_room
    case live_recommend
    case live_partition(id:Int)
    case drama_recommend
}

enum BilibiliOpenType: String {
    case login = "Bilibili://login"
}

extension BilibiliPushType {

    var transmitPath:String {
        switch self {
        case .recommend_rank:
            return "Bilibili://recommend/rank"
        case .live_beauty:
            return "Bilibili://live/beauty"
        case .live_recommend:
            return "Bilibili://live/recommend"
        case .live_room:
            return "Bilibili://live/room"
        case .live_partition(let id):
            return "Bilibili://live/partition/\(id)"
        case .drama_recommend:
            return "Bilibili://drama/recommend"
        
        }
    }
    
    var registerPath: String {
        switch self {
        case .recommend_rank:
            return "Bilibili://recommend/rank"
        case .live_beauty:
            return "Bilibili://live/beauty"
        case .live_recommend:
            return "Bilibili://live/recommend"
        case .live_room:
            return "Bilibili://live/room"
        case .live_partition:
            return "Bilibili://live/partition/<int:id>"
        case .drama_recommend:
            return "Bilibili://drama/recommend"
        }
    }
}

class BilibiliRouter {
    
    @discardableResult
    class func push(_ type:BilibiliPushType, context: Any? = nil) -> UIViewController? {
       
       return navigator.push(type.transmitPath, context: context)
    }
    
    @discardableResult
    class func push(_ url:String) -> UIViewController? {
        return navigator.push(url)
    }
    
    @discardableResult
    class func open(_ type: BilibiliOpenType) -> Bool? {
        return navigator.open(type.rawValue)
    }
}





