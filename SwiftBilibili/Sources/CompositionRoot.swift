//
//  CompositionRoot.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import CGFloatLiteral
import Kingfisher
import RxGesture
import RxOptional
import RxViewController
import SnapKit
import SwiftyColor
import SwiftyImage
import SwiftyUserDefaults
import Then
import URLNavigator
import NSObject_Rx
import ManualLayout
import GDPerformanceView_Swift
import Toaster
import Dollar
import WebKit
import SwiftDate

struct AppDependency {
    typealias OpenURLHandler = (_ url: URL, _ options: [UIApplicationOpenURLOptionsKey: Any]) -> Bool
    
    let window: UIWindow
    let configureSDKs: () -> Void
    let configureAppearance: () -> Void
    let configureUserAgent: () -> Void
    let congigurePerformance: () -> Void
    let openURL: OpenURLHandler
}

let navigator = Navigator()

final class CompositionRoot {

    /// Builds a dependency graph and returns an entry view controller.
    static func resolve() -> AppDependency {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.backgroundColor = .white
        window.makeKeyAndVisible()

        URLNavigationMap.initialize(navigator: navigator)
        
        let homeService = HomeService(networking: HomeNetworking())
        
        var presentMainScreen: (() -> Void)!

        presentMainScreen = {
            
            let mainTabBarController = MainTabBarController(reactor: MainTabBarViewReactor(),
                                                            homeParentViewController: HomeParentViewController(service: homeService),
                                                            attentionListViewController: AttentionListViewController(),
                                                            categoryListViewController: CategoryListViewController(),
                                                            discoveryListViewController: DiscoveryListViewController(),
                                                            mineListViewController: MineListViewController())
            
            window.rootViewController = mainTabBarController
        }
        
        let splashViewController = SplashViewController(presentMainScreen: presentMainScreen)
        
        window.rootViewController = splashViewController
        
        return AppDependency(
            window: window,
            configureSDKs: self.configureSDKs,
            configureAppearance: self.configureAppearance,
            configureUserAgent: self.configureUserAgent,
            congigurePerformance: self.congigurePerformance,
            openURL: self.openURLFactory(navigator: navigator)
        )
     }
     static func configureSDKs() {
        

     }
    
     static func configureAppearance() {
        //设置时区
        let regionRome = Region(tz: TimeZoneName.asiaShanghai, cal: CalendarName.gregorian, loc: LocaleName.chinese)
        
        Date.setDefaultRegion(regionRome)
        
        //打开app次数
        LocalManager.userInfo.openTimes += 1
        
        //设置环境  --默认是线上环境
        Defaults[.currentEnvironment] = .res
        
        //ToastView
        ToastView.appearance().font = Font.SysFont.sys_15
        ToastView.appearance().textColor = UIColor.db_white
        
     }
    
     static func configureUserAgent() {
        
        let webView = WKWebView(frame: .zero)
        webView.evaluateJavaScript("navigator.userAgent") { (oldAgent, error) in
            
            guard let oldAgent = oldAgent as? String else { return }
            
            let newAgent = "\(oldAgent) BiliApp/StudioApp/6560"
            let newAgentDic = ["UserAgent":newAgent]
            UserDefaults.standard.register(defaults: newAgentDic)
            if #available(iOS 9, *) {
                //局部更新,即可以在其他用到的webView页面重新修改userAgent
                webView.customUserAgent = newAgent
            }
        }
        webView.load(URLRequest(url: URL(string:"http//www.baidu.com")!))
     }
    
     static func congigurePerformance() {
        
        #if DEBUG
            GDPerformanceMonitor.sharedInstance.startMonitoring()
            GDPerformanceMonitor.sharedInstance.appVersionHidden = true
            GDPerformanceMonitor.sharedInstance.deviceVersionHidden = true
        #endif
     }
    
     static func openURLFactory(navigator: NavigatorType) -> AppDependency.OpenURLHandler {
        return { url, options -> Bool in
            if navigator.open(url) {
                return true
            }
            if navigator.present(url, wrap: MainNavigationController.self) != nil {
                return true
            }
            return false
        }
     }
}
