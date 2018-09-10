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
                case let .liveElement(_,sectionItem):
                   return liveListSectionDelegate.configureCell(collectionView: collectionView, indexPath: indexPath, sectionItem: sectionItem)
                }
              },
              configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                switch dataSource[indexPath] {
                case let .liveElement(sectionReactor, _):
                   return liveListSectionDelegate.supplementaryView(collectionView: collectionView, indexPath: indexPath,sectionReactor: sectionReactor,totalCount:dataSource.sectionModels.count,kind: kind)
                }
            }
          )
    }
    // MARK: View Life Cycle
    override func viewDidLoad() {
        
        self.collectionView.collectionViewLayout = BilibiliCollectionViewLayout()
        
        super.viewDidLoad()
        
        self.collectionView.enableDirection = true
        
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
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.sections}
            .subscribe(onNext: {[unowned self] (_) in
                self.hideAnimationView(self.collectionView)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: { (sectionItem) in
                switch sectionItem {
                case let .liveElement(_,item):
                    switch item {
                    case .av(let cellReactor):
                        log.info(cellReactor.live.play_url ?? "")
                        BilibiliRouter.push(.live_room)
                    default:break
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
        case let .liveElement(_,item):
            return self.liveListSectionDelegate.cellSize(collectionView: collectionView,indexPath: indexPath, sectionItem: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return liveListSectionDelegate.headerSize(collectionView: collectionView, section: section,viewSection:dataSource[section])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
    
        let liveSection = dataSource[section]
        switch liveSection {
        case .live(let sectionreactor):
            return liveListSectionDelegate.footerSize(collectionView: collectionView, section: section,sectionReactor:sectionreactor,totalCount: dataSource.sectionModels.count)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {

        return 0
    }
}

