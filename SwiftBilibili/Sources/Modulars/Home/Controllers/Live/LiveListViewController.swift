//
//  LiveListViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import RxSwift
import SwiftyUserDefaults

final class LiveListViewController: BaseCollectionViewController,View {

    private let liveListSectionDelegate: LiveListSectionDelegate
    private let dataSource: RxCollectionViewSectionedReloadDataSource<LiveListViewSection>

    // MARK: Initializing
    init(reactor: LiveListViewReactor,
         liveListSectionDelegateFactory: () -> LiveListSectionDelegate) {
      defer { self.reactor = reactor }
      self.liveListSectionDelegate = liveListSectionDelegateFactory()
      self.dataSource = type(of: self).dataSourceFactory(liveListSectionDelegate: self.liveListSectionDelegate)
      super.init()
      self.liveListSectionDelegate.registerReusables(to: collectionView)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private static func dataSourceFactory(
        liveListSectionDelegate:LiveListSectionDelegate)
        -> RxCollectionViewSectionedReloadDataSource<LiveListViewSection> {
            
            return .init(
              configureCell: { (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                switch sectionItem {
                case let .live(sectionItem):
                   return liveListSectionDelegate.configureCell(collectionView: collectionView, indexPath: indexPath, sectionItem: sectionItem)
                }
              },
              configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                 let section = dataSource[indexPath.section]
                 let sectionCount = dataSource.sectionModels.count
                
                return liveListSectionDelegate.supplementaryView(collectionView: collectionView, indexPath: indexPath,section: section,sectionCount:sectionCount,kind: kind)
            }
          )
    }
    
    override func setupConstraints() {
        
        collectionView.snp.remakeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    // MARK: View Life Cycle
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.allowListenScroll = true
        
        setupRefreshHeader(collectionView) {[unowned self] in
            self.reactor?.action.onNext(.refresh)
        }
        
        reactor?.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
        
    }

    // MARK: Configuring
    func bind(reactor: LiveListViewReactor) {
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.rx.viewDidLoad
            .map{Reactor.Action.refresh}
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
        
        reactor.state.map{$0.stopRotate}
            .filterNil()
            .subscribe(onNext: { (rotate) in
                
                let delayTime = rotate.1 ? kLivePartitionRefreshRotationTime/2 : kLivePartitionRefreshRotationTime
                
                DispatchQueue.delay(time: delayTime, action: {
                   NotificationCenter.post(customNotification: .stopRotate)
                })
         })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: { (sectionItem) in
                
                switch sectionItem {
                case let .live(item):
                    switch item {
                    case .av(let cellReactor):
                        log.info(cellReactor.live.play_url)
                        BilibiliRouter.push(.live_room)
                    case .beauty(let cellReactor):
                        log.info(cellReactor.live.play_url)
                        BilibiliRouter.push(.live_room)
                    case .banner:
                        BilibiliToaster.show("你点击我了")
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - UICollectionViewDelegateFlexLayout
extension LiveListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionItem = dataSource[indexPath]

        switch sectionItem {
        case let .live(item):
            return self.liveListSectionDelegate.cellSize(collectionView: collectionView,indexPath: indexPath, sectionItem: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        let viewSection = dataSource[section]
        
        if let _ = viewSection.header?.partitionType {
            return UIEdgeInsets(top: 0, left: kCollectionItemPadding, bottom: kCollectionItemPadding, right: kCollectionItemPadding)
        }
            return UIEdgeInsets(top: kCollectionItemPadding, left: kCollectionItemPadding, bottom: 2*kCollectionItemPadding, right: kCollectionItemPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return liveListSectionDelegate.headerSize(collectionView: collectionView, section: section,viewSection:dataSource[section],isShowStar: dataSource[0].starShows != nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    
        return liveListSectionDelegate.footerSize(collectionView: collectionView, section: section,viewSection:dataSource[section],sectionCount: dataSource.sectionModels.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return kCollectionItemPadding
    }
}

