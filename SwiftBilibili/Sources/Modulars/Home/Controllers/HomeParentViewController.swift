//
//  HomeParentViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import VTMagic

private enum HomeNavBarPosition {
    case none
    case normal
    case top
}

final class HomeParentViewController: BaseViewController {
    
    private struct Metric {
        static let statusBarHeight = isIphoneX ? 36.f : 20.f
        static let navBarHeight = 44.f
    }
    
    private var menuTitles : [String] = ["直播","推荐","追番"]
    
    private var requestIds : [Int] = []
    
    private let service: HomeServiceType
    
    private var idxs: [UInt] = []

    private var isRecodeDate: Bool = false
    
    private var lastOffestY: CGFloat = 0
    private var navBarPosition: HomeNavBarPosition = .normal
    private var lastNavBarPosition: HomeNavBarPosition = .none
    
    
    let pageController = VTMagicController().then{
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        $0.magicView.navigationColor = .db_white
        $0.magicView.sliderColor = .db_pink
        $0.magicView.switchStyle = .default
        $0.magicView.layoutStyle = .default
        $0.magicView.navigationHeight = 44.f
        $0.magicView.sliderExtension = 3
        $0.magicView.sliderOffset = 0
        $0.magicView.sliderHeight = 2
        $0.magicView.separatorColor = UIColor.db_lightGray
        $0.magicView.isSeparatorHidden = false
        $0.magicView.itemSpacing = 35
        $0.magicView.bubbleRadius = 2
    }
    
    let statusBar = UIView().then{
        $0.backgroundColor = UIColor.db_pink
    }
    
    let navBar = HomeNavBar.loadFromNib().then{
        $0.backgroundColor = UIColor.db_pink
    }
    
    init(service:HomeServiceType) {
        
        self.service = service
        super.init()
        
        self.tabBarItem.image = Image.TabBar.home
        self.tabBarItem.selectedImage = Image.TabBar.home_s?.withRenderingMode(.alwaysOriginal)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraints() {
        
        statusBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(Metric.statusBarHeight)
        }
        
        navBar.snp.remakeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(Metric.navBarHeight)
            make.top.equalTo(statusBar.snp.bottom)
        }
        
        pageController.view.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(navBar.snp.bottom)
        }
        

    }
    
    // MARK: StatusBar

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureMagicController()
        
        service.recommendBranch().asObservable()
            .subscribe(onNext: {[weak self] (rcmdBranchModel) in
                
                guard let `self` = self else { return }
                self.requestIds = rcmdBranchModel.tab.map{$0.id}
                self.menuTitles += rcmdBranchModel.tab.map{$0.name}
                self.pageController.magicView.reloadData(toPage: 1)
            })
            .disposed(by: disposeBag)
    }

    
    func configureMagicController() {
        
        self.view.addSubview(navBar)
        self.view.addSubview(statusBar)
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        
        pageController.magicView.delegate = self
        pageController.magicView.dataSource = self

        pageController.magicView.reloadData(toPage: 1)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let contentOffsetY = scrollView.contentOffset.y
        let distanceFromBottom = scrollView.contentSize.height - contentOffsetY
        let offset = contentOffsetY - self.lastOffestY
        self.lastOffestY = contentOffsetY
        
        if offset > 0 && contentOffsetY > 0 {
            scrollView.scrollDirection = .down
        }
        
        if offset < 0 && distanceFromBottom > height {
            scrollView.scrollDirection = .up
        }
        
        if self.lastNavBarPosition == self.navBarPosition { return }
        
        changeNavBarPosition(scrollDirection: scrollView.scrollDirection)
    }
    
    
    private func changeNavBarPosition(scrollDirection: ScrollDirection) {

        if scrollDirection == .down {
            if navBarPosition == .normal {
                lastNavBarPosition = .normal
                navBarPosition = .top
                UIView.animate(withDuration: 0.25) {
                    self.navBar.snp.remakeConstraints({ (make) in
                        make.bottom.equalTo(self.statusBar.snp.bottom)
                        make.left.right.equalToSuperview()
                        make.height.equalTo(Metric.navBarHeight)
                    })
                    self.view.layoutIfNeeded()
                }
            }
        }else if scrollDirection == .up {
            if navBarPosition == .top {
                lastNavBarPosition = .top
                navBarPosition = .normal
                UIView.animate(withDuration: 0.25) {
                    self.navBar.snp.remakeConstraints({ (make) in
                        make.top.equalTo(self.statusBar.snp.bottom)
                        make.left.right.equalToSuperview()
                        make.height.equalTo(Metric.navBarHeight)
                    })
                    self.view.layoutIfNeeded()
                }
            }
        }
    }
    
}

extension HomeParentViewController : VTMagicViewDelegate {
    
    func magicView(_ magicView: VTMagicView, didSelectItemAt itemIndex: UInt) {

        if itemIndex == 0 || itemIndex == 1 {
            guard let currentVc = pageController.currentViewController else { return }
            
            let currentPage = pageController.currentPage
            
            if currentPage == itemIndex {
                TogetherDataManager.refreshDataForVTMagic(currentVc,true)
            }
        }
    }
    
    func magicView(_ magicView: VTMagicView, viewDidAppear viewController: UIViewController, atPage pageIndex: UInt) {
        
        if pageIndex == 0 || pageIndex == 1 {
            var canRefresh: Bool = false
            
            if let collectionVc = viewController as? BaseCollectionViewController {
                
                if collectionVc.totalItems() > 0 {
                    canRefresh = true
                }
            }
            
            if idxs.contains(pageIndex) || canRefresh {
                
                TogetherDataManager.refreshDataForVTMagic(viewController, false)
            }
        }
    }
    
    func magicView(_ magicView: VTMagicView, viewDidDisappear viewController: UIViewController, atPage pageIndex: UInt) {
        
        if pageIndex == 0 || pageIndex == 1 {
            if !idxs.contains(pageIndex) {
                idxs.append(pageIndex)
            }
        }
        
        if pageIndex == 1 {
            TogetherDataManager.referenceDate = Date()
        }
    }
}

extension HomeParentViewController: VTMagicViewDataSource {
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return menuTitles
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        
        var menuItem = magicView.dequeueReusableItem(withIdentifier: "homeItemIdentifier")
        if menuItem == nil  {
            menuItem = UIButton(type: .custom)
            menuItem?.setTitleColor(.db_black, for: .normal)
            menuItem?.setTitleColor(.db_pink, for: .selected)
            menuItem?.titleLabel?.font = Font.SysFont.sys_15
        }
        
        return menuItem ?? UIButton()
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        
        if pageIndex == 0 {
            var liveController = magicView.dequeueReusablePage(withIdentifier: "LiveListViewController")
            if liveController == nil {
                let reactor = LiveListViewReactor(service: self.service)
                liveController = LiveListViewController(reactor: reactor, liveListSectionDelegateFactory: { () -> LiveListSectionDelegate in
                    LiveListSectionDelegate()
                })
            }
            return liveController ?? UIViewController()
        }else if pageIndex == 1 {
            var recommendController = magicView.dequeueReusablePage(withIdentifier: "RecommendParentViewController")
            if recommendController == nil {
                recommendController = RecommendParentViewController()
            }
            return recommendController ?? UIViewController()
        }else if pageIndex == 2 {
            var dramaController = magicView.dequeueReusablePage(withIdentifier: "DramaViewController")
            if dramaController == nil {
                let reactor = DramaViewReactor(service: service)
                dramaController = DramaViewController(reactor: reactor, dramaSectionDelegateFactory: { () -> DramaSectionDelegate in
                    DramaSectionDelegate()
                })
            }
            return dramaController ?? UIViewController()
        }else {
            var branchController = magicView.dequeueReusablePage(withIdentifier: "BranchViewController")
            if branchController == nil {
                branchController = BranchViewController(requestId:requestIds[Int(pageIndex) - 3])
            }
            return branchController ?? UIViewController()
        }
    }
}






