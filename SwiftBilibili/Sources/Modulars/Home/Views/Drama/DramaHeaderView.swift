//
//  DramaHeaderView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/20.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit


final class DramaHeaderView: UICollectionReusableView {
    
    private let mineDramaView = UIImageView().then{
        $0.contentMode = .scaleAspectFit
    }
    
    private let bottomGrayView = UIView().then{
        $0.backgroundColor = UIColor.db_gray
    }
    
    private let topGrayView = UIView().then{
        $0.backgroundColor = UIColor.db_gray
    }
    
    private let sectionTopView = DramaSectionTopView.loadFromNib()
    
    private let partitionHeaderView = LiveListPartitionHeaderView.loadFromNib()
    
    private var headerModel: DramaHeaderModel?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(sectionTopView)
        addSubview(topGrayView)
        addSubview(mineDramaView)
        addSubview(bottomGrayView)
        addSubview(partitionHeaderView)
        
        mineDramaView.rx.tapGesture()
            .when(.recognized)
            .subscribe(onNext: { (_) in
                
             if LocalManager.userInfo.isLogin {
                let context: [AnyHashable: Any] = ["isRcmd":true]
                BilibiliRouter.push(.drama_recommend,context:context)
             }else{
                BilibiliRouter.open(.login)
             }
         })
            .disposed(by: rx.disposeBag)
        
        partitionHeaderView.rx.tapGesture().subscribe(onNext: {[unowned self] (_) in
            
            guard let headerModel = self.headerModel else { return }
            
            switch headerModel.type {
            case .mine:
                let context: [AnyHashable: Any] = ["isRcmd":false]
                BilibiliRouter.push(.drama_recommend,context:context)
            case .edit: break
            default:
                BilibiliToaster.show(headerModel.type.title)
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(headerModel:DramaHeaderModel?,sectionCount:Int) {

        self.headerModel = headerModel
        
        guard let headerModel = headerModel else { return }
        
        let title = headerModel.type == .mine ? "查看全部" : "查看更多"
        
        let arrowNameAtt = NSMutableAttributedString(string: title)

        partitionHeaderView.reloadData(iconImage:headerModel.icon,partitionName: headerModel.name, arrowName: arrowNameAtt)
        
        if headerModel.type == .edit {
            partitionHeaderView.moreLabel.isHidden = true
            partitionHeaderView.arrowImageView.isHidden = true
        }else{
            partitionHeaderView.moreLabel.isHidden = false
            partitionHeaderView.arrowImageView.isHidden = false
        }
        
        if sectionCount == 5 {
            changeViewState(currentType: headerModel.type, expireType: .mine)
            mineDramaView.isHidden = true
            topGrayView.isHidden = true
        }else{//没有我的追番  需要判断是否登录放相应的图片
            changeViewState(currentType: headerModel.type, expireType: .drama)
            mineDramaView.image = LocalManager.userInfo.isLogin ? Image.Home.noDrama : Image.Home.bigLogin
        }
    }
    
    private func changeViewState(currentType:DramaSectionType, expireType: DramaSectionType) {
        
        if currentType == expireType {
            mineDramaView.isHidden = false
            topGrayView.isHidden = false
            sectionTopView.isHidden = false
        }else{
            mineDramaView.isHidden = true
            topGrayView.isHidden = true
            sectionTopView.isHidden = true
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        sectionTopView.snp.makeConstraints { (make) in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(130)
        }
        
        topGrayView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(sectionTopView.snp.bottom)
            make.height.equalTo(10)
        }
        
        mineDramaView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(topGrayView.snp.bottom)
            make.height.equalTo(120)
        }
        
        partitionHeaderView.snp.makeConstraints { (make) in
            make.bottom.equalTo(-10)
            make.left.equalTo(kCollectionItemPadding)
            make.right.equalTo(-kCollectionItemPadding)
            make.height.equalTo(30)
        }
        
        bottomGrayView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(partitionHeaderView.snp.top).offset(-10)
            make.height.equalTo(10)
        }
    }
    
}
