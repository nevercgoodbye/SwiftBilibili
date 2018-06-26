//
//  MainTabBarController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class MainTabBarController: UITabBarController,View {

    
    // MARK: Constants
    
    fileprivate struct Metric {
        static let tabBarHeight = 44.f
    }
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()

    init(
       reactor: MainTabBarViewReactor,
       homeParentViewController:HomeParentViewController,
       attentionListViewController:AttentionListViewController,
       categoryListViewController:CategoryListViewController,
       discoveryListViewController:DiscoveryListViewController,
       mineListViewController:MineListViewController
     ) {
        defer { self.reactor = reactor }
        super.init(nibName: nil, bundle: nil)
        self.viewControllers = [homeParentViewController,
                                attentionListViewController,
                                categoryListViewController,
                                discoveryListViewController,
                                mineListViewController]
            .map{ (viewController) -> UINavigationController in
                let navigationController = MainNavigationController(rootViewController: viewController)
                navigationController.tabBarItem.title = nil
                navigationController.tabBarItem.imageInsets.top = 5
                navigationController.tabBarItem.imageInsets.bottom = -5

                return navigationController
             }
        self.tabBar.barTintColor = .db_white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Configuring
    
    func bind(reactor: MainTabBarViewReactor) {
        
        self.rx.didSelect
            .scan((nil, nil)) { state, viewController in
                return (state.1, viewController)
            }.subscribe(onNext: { (fromVc,toVc) in
                
                if fromVc == toVc || fromVc == nil {
                    TogetherDataManager.refreshDataForTab(toVc, true)
                }else {
                    TogetherDataManager.refreshDataForTab(toVc, false)
                }
                if TogetherDataManager.homePageController(toVc) == nil {
                   TogetherDataManager.referenceDate = Date()
                }
            }).disposed(by: disposeBag)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if #available(iOS 11.0, *) {
            self.tabBar.height = Metric.tabBarHeight + self.view.safeAreaInsets.bottom
        } else {
            self.tabBar.height = Metric.tabBarHeight
        }
        self.tabBar.bottom = self.view.height
    }
}

