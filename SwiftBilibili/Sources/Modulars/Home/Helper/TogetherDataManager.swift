//
//  TogetherDataManager.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/6.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

class TogetherDataManager {

    static var referenceDate: Date?
    
    class func homePageController(_ viewController: UIViewController?) -> HomeParentViewController? {
        
        if let navigationController = viewController as? UINavigationController {
            let topViewController = navigationController.topViewController
            if let viewController = topViewController, viewController is HomeParentViewController {
                return viewController as? HomeParentViewController
            }
        }
        
        return nil
    }
    
    class func refreshDataForTab(_ viewController: UIViewController?, _ isForceRefresh:Bool = false) {
        
        if let homeVc = homePageController(viewController) {
            
            let magicController = homeVc.pageController
            
            let currentPage = magicController.currentPage
            
            if currentPage == 0 || currentPage == 1 {
                
                if let currentVc = magicController.currentViewController {
                    
                    refreshDataForVTMagic(currentVc, isForceRefresh)
                }
            }
        }
        
    }
    
    class func refreshDataForVTMagic(_ viewController: UIViewController?,
                                     _ isForceRefresh:Bool = false) {
        
        if viewController is RecommendParentViewController {
            
            let currentRcmdVc = (viewController as! RecommendParentViewController).pageController.currentViewController
            
            let currentRcmdPage = (viewController as! RecommendParentViewController).pageController.currentPage
            
            if currentRcmdPage != 0 { return }
            
            if let currentRcmdVc = currentRcmdVc,currentRcmdVc is TogetherViewController {
                
                if isForceRefresh {
                    (currentRcmdVc as! TogetherViewController).startRefresh()
                }else{
                    let isOver = ProcessTimeManager.overSetTime(referenceDate: referenceDate, compareDate: Date(), targetMinute: 1)
                    
                    if isOver {
                        (currentRcmdVc as! TogetherViewController).startRefresh()
                    }
                }
            }
            
        }else if viewController is LiveListViewController {
            
            if isForceRefresh {
                (viewController as! LiveListViewController).startRefresh()
            }else{
                (viewController as! LiveListViewController).reactor?.action.onNext(.refresh)
            }
        }
    }
}
