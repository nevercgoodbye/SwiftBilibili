//
//  URLNavigationMap.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/16.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import URLNavigator

final class URLNavigationMap {
    
    static func initialize(navigator:NavigatorType) {
        
        navigator.register(BilibiliPushType.recommend_rank.registerPath) { (url, values, context) -> UIViewController? in
            
            guard let context = context as? [String:Bool],
                  let isRcmd = context["isFromRcmd"]
                else { return nil }
            
            let rankParentVc = RankParentViewController()
            
            return rankParentVc
        }
        
        navigator.register(BilibiliPushType.live_beauty.registerPath) { (url, values, context) -> UIViewController? in
            let reactor = LiveBeautyViewReactor(service: HomeService(networking: HomeNetworking()))
            let beautyViewController = LiveBeautyViewController(reactor: reactor)
            return beautyViewController
        }
        
        navigator.register(BilibiliPushType.live_room.registerPath) { (url, values, context) -> UIViewController? in
            let roomViewController = LiveRoomViewController()
            return roomViewController
        }
        
        navigator.register(BilibiliPushType.live_recommend.registerPath) { (url, values, context) -> UIViewController? in
            let rcmdParentVc = LiveAllParentViewController(service:HomeService(networking: HomeNetworking()))
            return rcmdParentVc
        }
        
        navigator.register(BilibiliPushType.live_partition(id: 0).registerPath) { (url, values, context) -> UIViewController? in
            guard let partitionId = values["id"] as? Int,
                  let partitionType = LivePartitionType(rawValue: partitionId)
            else { return nil }
            let partitionVc = LivePartitionViewController(partitionType: partitionType, name:partitionType.title)
            return partitionVc
        }
        
        navigator.register(BilibiliPushType.drama_recommend.registerPath) { (url, values, context) -> UIViewController? in
            
            guard let context = context as? [String:Bool],
                  let isRcmd = context["isRcmd"]
            else { return nil }

            let rcmdVc = DramaRcmdViewController(isRcmd: isRcmd)
            
            return rcmdVc
        }
        
        
        navigator.register("http://<path:_>",self.webViewControllerFactory)
        navigator.register("https://<path:_>",self.webViewControllerFactory)
        navigator.handle(BilibiliOpenType.login.rawValue, self.login(navigator: navigator))
    }
    
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
        ) -> UIViewController? {
        return BilibiliWebViewController(link: url.urlStringValue)
    }
    
    private static func login(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in

            let loginController = LoginViewController()
            
            navigator.present(loginController, wrap: MainNavigationController.self)
            
            return true
        }
    }
}

