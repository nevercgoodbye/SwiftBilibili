//
//  DramaRcmdCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class DramaRcmdCell: BaseCollectionViewCell,View {
    
    private struct Metric {
        static let coverRcmdHeight = 120.f
        static let coverDramaHeight = 100.f
        static let coverRcmdWidth = 80.f
        static let coverDramaWidth = 70.f
        static let dramaButtonWidth = 60.f
        static let favouriteLabelLeft = 10.f
        static let titleLabelTop = 10.f
        static let titleLabelRight = -80.f
        static let latestUpdateLabelTop = 10.f
        static let tagLabelTop = 10.f
    }
    
    let coverImageView = UIImageView().then{
        $0.cornerRadius = kCornerRadius
    }
    
    let badgeButton = UIButton().then{
        $0.backgroundColor = UIColor.db_orange
        $0.setTitleColor(UIColor.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_10
        $0.isUserInteractionEnabled = false
        $0.contentEdgeInsets = UIEdgeInsetsMake(3, 3, 3, 3)
    }
    
    let favouriteLabel = UILabel().then{
        $0.textColor = UIColor.db_darkGray
        $0.font = Font.SysFont.sys_12
    }
    
    let titleLabel = UILabel().then{
        $0.textColor = UIColor.db_black
        $0.font = Font.SysFont.sys_13
    }
    
    let latestUpdateLabel = UILabel().then{
        $0.textColor = UIColor.db_pink
        $0.font = Font.SysFont.sys_12
    }
    
    let tagLabel = UILabel().then{
        $0.textColor = UIColor.db_darkGray
        $0.font = Font.SysFont.sys_12
    }
    
    let dramaButton = UIButton().then{
        $0.backgroundColor = UIColor.db_pink
        $0.setTitleColor(UIColor.db_white, for: .normal)
        $0.titleLabel?.font = Font.SysFont.sys_14
        $0.cornerRadius = 3
        $0.setTitle("追番", for: UIControlState.normal)
        $0.setTitle("已追番", for: UIControlState.selected)
    }
    
    let bottomLine = UIView().then{
        $0.backgroundColor = .db_lightGray
    }
    
    override func initialize() {
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.db_lightGray
        selectedBackgroundView = backgroundView
        
        contentView.addSubview(coverImageView)
        coverImageView.addSubview(badgeButton)
        contentView.addSubview(favouriteLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(latestUpdateLabel)
        contentView.addSubview(tagLabel)
        contentView.addSubview(dramaButton)
        contentView.addSubview(bottomLine)
    }
    
    func bind(reactor: DramaRcmdCellReactor) {
        
        let coverHeight = reactor.currentState.isRcmd ? Metric.coverRcmdHeight : Metric.coverDramaHeight
        let coverWidth = reactor.currentState.isRcmd ? Metric.coverRcmdWidth : Metric.coverDramaWidth
        let placeholderSize = CGSize(width: coverWidth, height: coverHeight)
        
        reactor.state.map{$0.coverURL}
            .bind(to: coverImageView.rx.image(placeholder: .placeholderImage(bgSize:placeholderSize)))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.title}
            .distinctUntilChanged()
            .bind(to: titleLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.badge}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: badgeButton.rx.title(for: .normal))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.latestUpdate}
            .distinctUntilChanged()
            .bind(to: latestUpdateLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.tagDesc}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: tagLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.latestUpdateColor}
            .distinctUntilChanged()
            .bind(to: latestUpdateLabel.rx.textColor)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.badge == nil}
            .distinctUntilChanged()
            .bind(to: badgeButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.tagDesc == nil}
            .distinctUntilChanged()
            .bind(to: tagLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map{!$0.isRcmd}
            .distinctUntilChanged()
            .bind(to: dramaButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.isHiddenLine}
            .distinctUntilChanged()
            .bind(to: bottomLine.rx.isHidden)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.favourites}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: favouriteLabel.rx.text)
            .disposed(by: disposeBag)

        reactor.state.map{$0.watchProgress}
            .filterNil()
            .distinctUntilChanged()
            .bind(to: favouriteLabel.rx.text)
            .disposed(by: disposeBag)
        
    
        dramaButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            
            self.dramaButton.isSelected = !self.dramaButton.isSelected
            self.dramaButton.backgroundColor = self.dramaButton.isSelected ? UIColor.db_darkGray : UIColor.db_pink
            guard let season_id = reactor.currentState.season_id,
                  let season_type = reactor.currentState.season_type
            else { return }
            
            if self.dramaButton.isSelected {
                reactor.action.onNext(.follow(season_id: season_id, season_type: season_type))
            }else{
                reactor.action.onNext(.unFollow(season_id: season_id, season_type: season_type))
            }
        }).disposed(by: disposeBag)
        
    }
    
    class func cellSize(reactor:DramaRcmdCellReactor) -> CGSize {
    
        var cellHeight = reactor.currentState.isRcmd ? Metric.coverRcmdHeight : Metric.coverDramaHeight
        cellHeight += 2 * kCollectionItemPadding
        
        return CGSize(width: kScreenWidth, height: cellHeight)
    }
    

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let coverHeight = reactor!.currentState.isRcmd ? Metric.coverRcmdHeight : Metric.coverDramaHeight
        let coverWidth = reactor!.currentState.isRcmd ? Metric.coverRcmdWidth : Metric.coverDramaWidth
        
        coverImageView.snp.makeConstraints { (make) in
            make.width.equalTo(coverWidth)
            make.height.equalTo(coverHeight)
            make.left.equalTo(kCollectionItemPadding)
            make.top.equalTo(kCollectionItemPadding)
        }
        
        dramaButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalTo(-kCollectionItemPadding)
            make.width.equalTo(Metric.dramaButtonWidth)
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(coverImageView.snp.right).offset(kCollectionItemPadding)
            make.top.equalTo(coverImageView.snp.top).offset(Metric.titleLabelTop)
            make.right.equalTo(Metric.titleLabelRight)
        }
        
        if reactor!.currentState.isRcmd {
            latestUpdateLabel.snp.makeConstraints { (make) in
                make.centerY.equalTo(dramaButton)
                make.left.equalTo(titleLabel)
            }
        }else{
            latestUpdateLabel.snp.makeConstraints({ (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(Metric.tagLabelTop)
                make.left.equalTo(titleLabel)
            })
        }
        
        favouriteLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(latestUpdateLabel.snp.bottom).offset(Metric.tagLabelTop)
        }
        
        tagLabel.snp.makeConstraints { (make) in
            make.left.equalTo(titleLabel)
            make.top.equalTo(favouriteLabel.snp.bottom).offset(Metric.tagLabelTop)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
    }
}
