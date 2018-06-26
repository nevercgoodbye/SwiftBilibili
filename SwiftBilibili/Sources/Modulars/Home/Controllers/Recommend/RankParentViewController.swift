//
//  RankParentViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import VTMagic

final class RankParentViewController: BaseViewController {

    private let regions: [RankRegionType] = [.wholeStation,.drama,.animation,.country,.music,.dance,.game,.technology,.life,.ghost,.fashion,.entertainment,.movie,.recoder,.film,.tv]
    
    private var idxs: [Int: RankViewController] = [:]
    
    private let pageController = VTMagicController().then{
        $0.view.translatesAutoresizingMaskIntoConstraints = false
        $0.magicView.navigationColor = .db_pink
        $0.magicView.sliderColor = .db_white
        $0.magicView.switchStyle = .default
        $0.magicView.layoutStyle = .center
        $0.magicView.navigationHeight = 44.f
        $0.magicView.isAgainstStatusBar = true
        $0.magicView.sliderExtension = 4
        $0.magicView.separatorHeight = 0
        $0.magicView.sliderOffset = -5
        $0.magicView.sliderHeight = 3
    }
    
    private let backButton = UIButton(frame:CGRect(x: 0, y: 0, width: 50, height: 25)).then{
        $0.setImage(Image.Home.back, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
    }
    
    override func setupConstraints() {
        pageController.view.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureMagicController()
        
        backButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            
            self.navigationController?.popViewController(animated: true)
            
        }).disposed(by: disposeBag)
    }

    private func configureMagicController() {
        
        self.addChildViewController(pageController)
        self.view.addSubview(pageController.view)
        
        pageController.magicView.leftNavigatoinItem = backButton
        pageController.magicView.dataSource = self
        pageController.magicView.reloadData()
    }

}

extension RankParentViewController: VTMagicViewDataSource {
    
    func menuTitles(for magicView: VTMagicView) -> [String] {
        return regions.map{$0.title}
    }
    
    func magicView(_ magicView: VTMagicView, menuItemAt itemIndex: UInt) -> UIButton {
        
        var menuItem = magicView.dequeueReusableItem(withIdentifier: "homeItemIdentifier")
        if menuItem == nil  {
            menuItem = UIButton(type: .custom)
            menuItem?.setTitleColor(.db_gray, for: .normal)
            menuItem?.setTitleColor(.db_white, for: .selected)
            menuItem?.titleLabel?.font = Font.SysFont.sys_15
        }
        
        return menuItem ?? UIButton()
    }
    
    func magicView(_ magicView: VTMagicView, viewControllerAtPage pageIndex: UInt) -> UIViewController {
    
        if !idxs.keys.contains(Int(pageIndex)) {
            let rankController = RankViewController()
            idxs.updateValue(rankController, forKey: Int(pageIndex))
            return rankController
        }
        
        let rankController = idxs[Int(pageIndex)]!
        
        return rankController
    
    }
}

