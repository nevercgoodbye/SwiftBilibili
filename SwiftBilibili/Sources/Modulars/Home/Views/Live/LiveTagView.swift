//
//  LiveTagView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/9/9.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LiveTagView: UIView {
    
    struct Metric {
        static let leftMargin = 30.f
        static let buttonHeight = 50.f
        static let buttonWidth = 30.f
    }
    
    let containView = UIStackView().then{
        $0.axis = .vertical
        $0.distribution = .fillEqually
    }
    
    let firstHorizontalView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    let seecondHorizontalView = UIStackView().then{
        $0.axis = .horizontal
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(containView)

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupData(liveModels:[LiveAvModel],tagModels:[LiveTagModel]) {
        
        if containView.arrangedSubviews.count > 0 { return }
        containView.addArrangedSubview(firstHorizontalView)
        containView.addArrangedSubview(seecondHorizontalView)
        
        
        for tagModel in tagModels {

            let verButton = self.createVerButton(imageUrl: tagModel.pic ?? "", title: tagModel.name ?? "",link: tagModel.parent_name ?? "")
            self.firstHorizontalView.addArrangedSubview(verButton)
        }
        
        for avModel in liveModels {
            
            let verButton = self.createVerButton(imageUrl: avModel.pic ?? "", title: avModel.title ?? "",link: avModel.link ?? "")
            self.seecondHorizontalView.addArrangedSubview(verButton)
        }
    }
    
    private func createVerButton(imageUrl:String,title:String,link:String) -> BilibiliButton {
        let verButton = BilibiliButton(type: .custom)
        verButton.imagePosition = .top
        verButton.imageSize = CGSize(width: 40, height: 40)
        verButton.setTitle(title, for: .normal)
        
        verButton.titleLabel?.font = Font.SysFont.sys_14
        verButton.setTitleColor(UIColor.db_black, for: .normal)
        verButton.setImage(with: URL(string:imageUrl), for: .normal)
    
        verButton.rx.tap.subscribe(onNext: { (_) in
            
            BilibiliRouter.open(link)
            
        }).disposed(by: rx.disposeBag)
        
        return verButton
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        containView.snp.makeConstraints { (make) in
            make.left.equalTo(kCollectionItemPadding)
            make.right.equalTo(-kCollectionItemPadding)
            make.top.equalTo(kCollectionItemPadding)
            make.bottom.equalTo(-kCollectionItemPadding)
        }
    }

}
