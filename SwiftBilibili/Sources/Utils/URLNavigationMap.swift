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
        
        navigator.register(BilibiliPushType.recommend_rank.path) { (url, values, context) -> UIViewController? in
            
            guard let context = context as? [String:Bool],
                  let isRcmd = context["isFromRcmd"]
            else { return nil }
            
            let rankParentVc = RankParentViewController()
            
            return rankParentVc
        }
        
        navigator.register(BilibiliPushType.live_room.path) { (url, values, context) -> UIViewController? in
            let roomViewController = LiveRoomViewController()
            return roomViewController
        }
        
        navigator.register(BilibiliPushType.live_all.path) { (url, values, context) -> UIViewController? in
            let rcmdParentVc = LiveAllParentViewController(service:HomeService(networking: HomeNetworking()))
            return rcmdParentVc
        }
        
        navigator.register(BilibiliPushType.recommend_player.path) { (url, values, context) -> UIViewController? in
            let testVc = TestViewController()
            return testVc
        }
        
        navigator.register(BilibiliPushType.drama_recommend.path) { (url, values, context) -> UIViewController? in
            
            guard let context = context as? [String:Bool],
                  let isRcmd = context["isRcmd"]
            else { return nil }

            let rcmdVc = DramaRcmdViewController(isRcmd: isRcmd)
            
            return rcmdVc
        }
        
        navigator.register("http://<path:_>",self.webViewControllerFactory)
        navigator.register("https://<path:_>",self.webViewControllerFactory)
        navigator.handle(BilibiliOpenType.area.rawValue, self.area(navigator: navigator))
        navigator.handle(BilibiliOpenType.all.rawValue, self.all(navigator: navigator))
        navigator.handle(BilibiliOpenType.login.rawValue, self.login(navigator: navigator))
    }
    
    private static func webViewControllerFactory(
        url: URLConvertible,
        values: [String: Any],
        context: Any?
        ) -> UIViewController? {
        
        let link = url.urlStringValue
        
        if link.contains("read") {
            return BilibiliArticleViewController(link: link)
        }else{
            return BilibiliWebViewController(link: url.urlStringValue)
        }
    }
    
    private static func area(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in

            let parent_area_id = url.queryParameters["parent_area_id"]!
            let parent_area_name = url.queryParameters["parent_area_name"]!
            let area_id = url.queryParameters["area_id"]!
            let area_name = url.queryParameters["area_name"]!
            
            let partitionController = LivePartitionViewController(parent_area_id: parent_area_id,
                                                                  parent_area_name: parent_area_name,
                                                                  area_id: area_id,
                                                                  area_name: area_name)
            navigator.push(partitionController)
            return true
        }
    }
    
    private static func all(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            
            let allParentVc = LiveAllParentViewController(service: HomeService(networking: HomeNetworking()))
            navigator.push(allParentVc)
            return true
        }
    }
    
    private static func login(navigator: NavigatorType) -> URLOpenHandlerFactory {
        return { url, values, context in
            
            let loginController = LoginViewController()
            navigator.present(loginController, wrap: MainNavigationController.self)
            return true
        }
    }
    
}

