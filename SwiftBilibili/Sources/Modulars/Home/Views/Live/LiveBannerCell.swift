//
//  LiveBannerCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import URLNavigator

final class LiveBannerCell: BaseCollectionViewCell,View {
    
    private struct Metric {
        static let bottomViewHeight = 30.f
    }
    
    
    // MARK: Types
    struct Dependency {
        let imageOptions: ImageOptions
        let navigator: NavigatorType
        //let LiveListViewControllerFactory: (_ id: Int, _ shot: Shot?) -> ShotViewController
    }
    
    // MARK: Properties
    var dependency: Dependency?
    
    
    // MARK: UI
    private let backgroundImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
        $0.backgroundColor = .db_white
        $0.isUserInteractionEnabled = true
    }
    
    private let coverImageView = UIImageView().then{
        $0.isUserInteractionEnabled = true
    }
    
    private let bottomView = UIView().then{
        $0.backgroundColor = .db_white
    }
    
    private let titleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_14
        $0.textColor = .db_black
    }
    
    // MARK: Initializing
    override func initialize() {
        contentView.addSubview(backgroundImageView)
        backgroundImageView.addSubview(coverImageView)
        backgroundImageView.addSubview(bottomView)
        bottomView.addSubview(titleLabel)
    }
    
    // MARK: Configuring
    func bind(reactor: LiveBannerCellReactor) {
        
        //guard let dependency = self.dependency else { preconditionFailure() }

        reactor.state.map{$0.title}
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { _ in }
            .bind(to: self.rx.setNeedsLayout)
            .disposed(by: self.disposeBag)
        
        coverImageView.setImage(with: reactor.currentState.coverURL, placeholder: .placeholderImage(bgSize:CGSize(width: kScreenWidth - 2*kCollectionItemPadding, height: reactor.currentState.coverHeight*0.6)))
        
    }
    // MARK: Size
    class func size(width: CGFloat, reactor: LiveBannerCellReactor) -> CGSize {
        
        let height = reactor.currentState.coverHeight * 0.6 + Metric.bottomViewHeight
        
        return CGSize(width: width, height: height)
    }
    
    // MARK: Layout
    override func layoutSubviews() {
        super.layoutSubviews()
    
        setShadow()
        
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        coverImageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(reactor!.currentState.coverHeight * 0.6)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(Metric.bottomViewHeight)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(10)
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }

    }
}
