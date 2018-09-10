//
//  TogetherViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift
import URLNavigator

final class TogetherViewController: BaseCollectionViewController,View {

    // MARK: Properties
    let togetherSectionDelegate: TogetherSectionDelegate
    let dataSource: RxCollectionViewSectionedReloadDataSource<TogetherViewSection>
    
    // MARK: UI
    let countButton = UIButton().then{
        $0.titleLabel?.font = Font.SysFont.sys_13
        $0.setTitleColor(UIColor.db_white, for: .normal)
        $0.backgroundColor = UIColor.db_black.withAlphaComponent(0.8)
        $0.contentEdgeInsets = UIEdgeInsetsMake(10, 15, 10, 15)
        $0.alpha = 0
        $0.cornerRadius = 4
        $0.isUserInteractionEnabled = false
    }
    
    let adView = TogetherAdView.loadFromNib()
    
    // MARK: Initializing
    init(reactor:TogetherViewReactor,
         togetherSectionDelegateFactory: () -> TogetherSectionDelegate) {
        defer { self.reactor = reactor }
        self.togetherSectionDelegate = togetherSectionDelegateFactory()
        self.dataSource = type(of: self).dataSourceFactory(togetherSectionDelegate: self.togetherSectionDelegate)
        super.init()
        self.togetherSectionDelegate.registerReusables(to: self.collectionView)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func dataSourceFactory(
        togetherSectionDelegate:TogetherSectionDelegate)
        -> RxCollectionViewSectionedReloadDataSource<TogetherViewSection> {
        
            return .init(configureCell: { (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                switch sectionItem {
                case let .together(item):
                    return togetherSectionDelegate.configureCell(collectionView: collectionView, indexPath: indexPath,sectionItem: item)
                }
            })
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
        self.collectionView.enableDirection = true
        
        setupRefreshHeader(collectionView) {[unowned self] in
            self.reactor?.action.onNext(.refresh(.pullRefresh, false))
        }
        
        reactor?.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
    }
    
    //MARK: Parent Method
    override func showNetErrorView() {
        
        let isCache = RealmManager.selectByAll(TogetherRealmModel.self).count > 0
       
       if isCache { return }
        
       super.showNetErrorView()
    }
    
    // MARK: Configuring
    func bind(reactor: TogetherViewReactor) {
        
        // Input
        self.rx.viewDidLoad
            .map{Reactor.Action.refresh(.none, true)}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewDidLoad
            .map{Reactor.Action.showAd}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        collectionView.rx.isReachedBottom
            .map{Reactor.Action.loadMore}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: {[unowned self] (sectionItem) in
            
            switch sectionItem {
            case let .together(item):
                switch item {
                case .tip:
                   self.startRefresh()
                case let .ad(cellReactor):
                   BilibiliRouter.push(cellReactor.together.uri ?? "")
                case .av:
                   BilibiliRouter.push(BilibiliPushType.recommend_player)
                case .article(let cellReactor):
                   BilibiliRouter.push(cellReactor.together.uri ?? "")
                default:break
                }
            }
        })
            .disposed(by: disposeBag)
        
        // Output
        reactor.state.map{$0.sections}
            .filterNil()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.sections}
            .filterNil()
            .subscribe(onNext: {[unowned self] (_) in
                self.hideLoadAnimation()
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.moveCount}
            .filterNil()
            .distinctUntilChanged()
            .subscribe(onNext: {[unowned self] (count) in
               self.showTipView(title: "发现\(count)条新内容")
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.adModel}
            .filterNil()
            .single()
            .distinctUntilChanged()
            .subscribe(onNext: {[unowned self] (adModel) in
                UIApplication.shared.isStatusBarHidden = true
                self.adView.startCountDown(adModel: adModel)
            })
            .disposed(by: disposeBag)
        
//        reactor.state.map{$0.isRefreshFailue}
//            .distinctUntilChanged()
//            .subscribe(onNext: {[unowned self] (isRefreshFailue) in
//                if isRefreshFailue {
//                   self.showTipView(title: "技能冷却中,稍后再试")
//                }
//            })
//            .disposed(by: disposeBag)
//
//        reactor.state.map{$0.isLoadMoreFailue}
//            .distinctUntilChanged()
//            .subscribe(onNext: { (isLoadMoreFailue) in
//                log.info("============================我被调用了===========================")
//                if isLoadMoreFailue {
//                   BilibiliToaster.show("技能冷却中,稍后再试", bottomOffsetPortrait: 120.f*kScreenRatio)
//                }
//           })
//            .disposed(by: disposeBag)
    }
    //Private Method
    private func showTipView(title:String) {
       
        let countButtonH = 40.f

        countButton.setTitle(title, for: .normal)
        view.addSubview(countButton)
        view.bringSubview(toFront: countButton)
        
        countButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.top)
            make.height.equalTo(countButtonH)
        }
        
        //移动动画
        UIView.animate(withDuration: 0.5, animations: {
            self.countButton.transform = CGAffineTransform(translationX: 0, y: 120)
            self.countButton.alpha = 1
        }) { (_) in
            DispatchQueue.delay(time: 1, action: {[unowned self] in
                UIView.animate(withDuration: 0.5, animations: {
                    self.countButton.transform = CGAffineTransform.identity
                    self.countButton.alpha = 0
                }, completion: { (_) in
                    self.countButton.removeFromSuperview()
                })
            })
        }
    }
    
}
// MARK: - UICollectionViewDelegateFlowLayout
extension TogetherViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return  UIEdgeInsets(top: 0, left: kCollectionItemPadding, bottom: kCollectionItemPadding, right: kCollectionItemPadding)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionItem = dataSource[indexPath]
        switch sectionItem {
        case let .together(item):
            return self.togetherSectionDelegate.cellSize(collectionView: collectionView,indexPath: indexPath, sectionItem: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return kCollectionItemPadding
    }
}


