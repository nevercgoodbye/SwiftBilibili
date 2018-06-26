//
//  AppDelegate.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    // MARK: Properties
    
    var dependency: AppDependency!
    
    
    // MARK: UI
    
    var window: UIWindow?

    // MARK: UIApplicationDelegate

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        self.dependency = self.dependency ?? CompositionRoot.resolve()
        self.window = self.dependency.window
        self.dependency.configureSDKs()
        self.dependency.configureAppearance()
        self.dependency.configureUserAgent()
        self.dependency.congigurePerformance()
        return true
    }

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplicationOpenURLOptionsKey: Any] = [:]
        ) -> Bool {
        return self.dependency.openURL(url, options)
    }
}

