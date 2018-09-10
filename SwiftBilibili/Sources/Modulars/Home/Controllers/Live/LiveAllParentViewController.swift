//
//  LiveAllParentViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/23.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import VTMagic

final class LiveAllParentViewController: BaseViewController {

    private let service: HomeServiceType
    
    private let regions: [LiveAllSubType] = [.hottest,.latest,.roundroom]
    
    private var idxs: [Int: LiveAllViewController] = [:]
    
    let pageController = VTMagicController().then{
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        $0.magicView.navigationColor = .db_pink
        $0.magicView.sliderColor = .db_white
        $0.magicView.layoutStyle = .center
        $0.magicView.navigationHeight = 44.f
        $0.magicView.sliderExtension = 6
        $0.magicView.separatorHeight = 0
        $0.magicView.sliderOffset = -3
        $0.magicView.sliderHeight = 3
        $0.magicView.itemSpacing = 30
    }
    
    init(service: HomeServiceType) {
        self.service = service
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupConstraints() {
        pageController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "全部直播"
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        pageController.magicView.dataSource = self
        pageController.magicView.reloadData()
    }
}

//此处没有循环利用
extension LiveAllParentViewController: VTMagicViewDataSource {
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return regions.map{$0.rawValue}
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        
        var menuItem = magicView.dequeueReusableItem(withIdentifier: "rcmdItemIdentifier")
        if menuItem == nil  {
            menuItem = UIButton(type: .custom)
            menuItem?.setTitleColor(.db_gray, for: .normal)
            menuItem?.setTitleColor(.db_white, for: .selected)
            menuItem?.titleLabel?.font = Font.SysFont.sys_14
            
        }
        
        return menuItem ?? UIButton()
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
        
        if !idxs.keys.contains(Int(pageIndex)) {
            let reactor = LiveAllViewReactor(homeService: service,subType: regions[Int(pageIndex)])
            let allController = LiveAllViewController(reactor: reactor)
            idxs.updateValue(allController, forKey: Int(pageIndex))
            return allController
        }
        
        let allController = idxs[Int(pageIndex)]!
        
        return allController
     }
}
