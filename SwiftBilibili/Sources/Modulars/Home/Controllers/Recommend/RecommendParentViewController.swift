//
//  RecommendViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import VTMagic

import URLNavigator

final class RecommendParentViewController: BaseViewController {

    let pageController = VTMagicController().then{
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        $0.magicView.navigationColor = .db_gray
        $0.magicView.switchStyle = .default
        $0.magicView.layoutStyle = .default
        $0.magicView.navigationHeight = 44.f
        $0.magicView.separatorColor = .db_lightGray
        $0.magicView.separatorHeight = 0.5
        $0.magicView.sliderHeight = 0.f
        $0.magicView.needPreloading = false
        $0.magicView.itemSpacing = 28
        $0.magicView.isSeparatorHidden = true
    }
    
    private let rightItemView = RecommendRightItemView.loadFromNib().then{
        $0.backgroundColor = .clear
        $0.frame = CGRect(x: 0, y: 0, width: 80, height: 40)
    }
    
    override func setupConstraints() {
        pageController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.magicView.rightNavigatoinItem = rightItemView
        pageController.magicView.dataSource = self
        pageController.magicView.reloadData()
    }
}

extension RecommendParentViewController : VTMagicViewDataSource {

    func menuTitles(for magicView: VTMagicView) -> [String] {
        return ["综合"]
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        
        var menuItem = magicView.dequeueReusableItem(withIdentifier: "recommendItemIdentifier")
        if menuItem == nil  {
            menuItem = UIButton(type: .custom)
            menuItem?.setTitleColor(.db_darkGray, for: .normal)
            menuItem?.setTitleColor(.db_darkGray, for: .selected)
            menuItem?.titleLabel?.font = Font.SysFont.sys_13
        }
        
        return menuItem ?? UIButton()
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        
        var togetherController = magicView.dequeueReusablePage(withIdentifier: "TogetherViewController")
        if togetherController == nil {
            let reactor = TogetherViewReactor(homeService: HomeService(networking: HomeNetworking()))
            togetherController = TogetherViewController(
                reactor: reactor,
                togetherSectionDelegateFactory: {
                    TogetherSectionDelegate()
                })
        }
        return togetherController ?? UIViewController()
        
    }
}


