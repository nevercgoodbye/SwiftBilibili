//
//  DramaViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

/** 注释的代码打开就是之前兔耳朵下拉刷新 setupRefreshHeader(collectionView,.rabbit) 由于B站样式调整故打开兔耳朵样式会有点问题  */

import UIKit

import ReactorKit
import RxDataSources
import RxSwift

final class DramaViewController: BaseCollectionViewController,View {

    private let dramaSectionDelegate: DramaSectionDelegate
    private let dataSource: RxCollectionViewSectionedReloadDataSource<DramaViewSection>
    
    init(reactor:DramaViewReactor,
         dramaSectionDelegateFactory: () -> DramaSectionDelegate
        ) {
       defer { self.reactor = reactor }
       self.dramaSectionDelegate = dramaSectionDelegateFactory()
        self.dataSource = type(of: self).dataSourceFactory(dramaSectionDelegate: self.dramaSectionDelegate)
       super.init()
       self.dramaSectionDelegate.registerReusables(to: collectionView)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func dataSourceFactory(
        dramaSectionDelegate:DramaSectionDelegate)
        -> RxCollectionViewSectionedReloadDataSource<DramaViewSection> {
            
            return .init(
                configureCell: { (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                    switch sectionItem {
                    case let .drama(sectionItem):
                        return dramaSectionDelegate.configureCell(collectionView: collectionView, indexPath: indexPath, sectionItem: sectionItem)
                    }
            },
                configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                    let section = dataSource[indexPath.section]
                    
                    return dramaSectionDelegate.supplementaryView(collectionView: collectionView, indexPath: indexPath,section:section,sectionCount:dataSource.sectionModels.count, kind: kind)
            }
         )
    }
    
//    //布局子类处理
//    override func setupConstraints() {}
//
//    //网络请求错误子类处理 -- 自己处理刷新成功与否的文字 更新成功或更新失败
//    override func registerNetErrorNotification() {}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor.db_pink
//        collectionView.cornerRadius = kCornerRadius
//        collectionView.frame = self.view.bounds
        collectionView.backgroundColor = UIColor.white
        setupRefreshHeader(collectionView) {[unowned self] in
            self.reactor?.action.onNext(.refresh)
        }
        
        reactor?.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
    }
    
    func bind(reactor: DramaViewReactor) {
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.rx.viewDidLoad
            .map{Reactor.Action.refresh}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        self.rx.viewWillAppear
            .map{_ in Reactor.Action.updateMineDrama}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        collectionView.rx.isReachedBottom
            .map{Reactor.Action.loadMore}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.sections}
            .filterNil()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.sections}
            .filterNil()
            .subscribe(onNext: {[unowned self] (_) in
                self.hideAnimationView(self.collectionView)
            })
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.isSuccess}
            .subscribe(onNext: {[unowned self] (isSuccess) in
                
                (self.collectionView.header?.animator as? RabbitHeaderAnimator)?.isSuccess = isSuccess
                
                if !isSuccess {
                    self.stopRefresh()
                    self.showNetErrorView()
                }
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: { (sectionItem) in
                
                switch sectionItem {
                case .drama(let item):
                    switch item {
                    case .vertical(let cellReactor):
                       BilibiliToaster.show(cellReactor.currentState.title)
                    case .review(let cellReactor):
                       BilibiliToaster.show(cellReactor.currentState.title)
                    case .edit(let cellReactor):
                       BilibiliToaster.show(cellReactor.currentState.title)
                    }
                }
            })
            .disposed(by: disposeBag)
        
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension DramaViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionItem = dataSource[indexPath]
        
        switch sectionItem {
        case let .drama(item):
            return self.dramaSectionDelegate.cellSize(collectionView: collectionView,indexPath: indexPath, sectionItem: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let type = dataSource[section].headerModel!.type
        
        if type == .review {
            return UIEdgeInsets.zero
        }
        return UIEdgeInsets(top: 0, left: kCollectionItemPadding, bottom: 0, right: kCollectionItemPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kCollectionItemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.f
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return dramaSectionDelegate.headerSize(collectionView: collectionView,section: dataSource[section],sectionCount: dataSource.sectionModels.count)
    }
}


