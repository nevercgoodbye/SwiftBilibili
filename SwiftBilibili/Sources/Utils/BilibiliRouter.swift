//
//  BilibiliRouter.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/18.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import URLNavigator


enum BilibiliPushType {
    case recommend_rank
    case recommend_player
    case live_room
    case live_all
    case drama_recommend
}


enum BilibiliOpenType: String {
    case area = "http://live.bilibili.com/app/area"
    case common = "http://live.bilibili.com/app/mytag/"
    case attention = "http://live.bilibili.com/app/myfollow/"
    case all = "http://live.bilibili.com/app/all-live/"
    
    case login = "Bilibili://app/login"
}

extension BilibiliPushType {

    var path:String {
        switch self {
        case .recommend_rank:
            return "Bilibili://recommend/rank"
        case .recommend_player:
            return "Bilibili://recommend/player"
        case .live_all:
            return "Bilibili://live/recommend"
        case .live_room:
            return "Bilibili://live/room"
        case .drama_recommend:
            return "Bilibili://drama/recommend"

        }
    }
}

class BilibiliRouter {
    
    @discardableResult
    class func push(_ type:BilibiliPushType, context: Any? = nil) -> UIViewController? {
       
       return navigator.push(type.path, context: context)
    }
    
    @discardableResult
    class func push(_ url:String) -> UIViewController? {
        
        return navigator.push(url)
    }
    
    @discardableResult
    class func open(_ url:String) -> Bool? {
        
        guard let header = url.components(separatedBy: "?").first,
              let _ = BilibiliOpenType(rawValue: header)
        else {
            BilibiliToaster.show("需要跳转的路径未找到,请先注册")
            return nil
        }
        
        return navigator.open(url)
    }
}





