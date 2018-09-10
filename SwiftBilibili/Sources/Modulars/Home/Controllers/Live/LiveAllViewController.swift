//
//  LiveAllViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReusableKit
import RxSwift
import RxCocoa
import RxDataSources
import ReactorKit

final class LiveAllViewController: BaseCollectionViewController,View {

    private struct Reusable {
        static let avCell = ReusableCell<LiveAvCell>()
        static let roundRoomCell = ReusableCell<LiveRoundRoomCell>()
    }
    
    let dataSource: RxCollectionViewSectionedReloadDataSource<LiveAllViewSection>
    
    init(reactor: LiveAllViewReactor) {
       defer { self.reactor = reactor }
       self.dataSource = type(of: self).dataSourceFactory()
       super.init()
       collectionView.register(Reusable.avCell)
       collectionView.register(Reusable.roundRoomCell)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func dataSourceFactory()
        -> RxCollectionViewSectionedReloadDataSource<LiveAllViewSection> {
            
            return .init(configureCell: { (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                switch sectionItem {
                case .av(let cellReactor):
                    let cell = collectionView.dequeue(Reusable.avCell, for: indexPath)
                    cell.reactor = cellReactor
                    return cell
                case .roundRoom(let cellReactor):
                    let cell = collectionView.dequeue(Reusable.roundRoomCell, for: indexPath)
                    cell.reactor = cellReactor
                    return cell
                }
            })
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        isEmptyDisplay = false
        
        setupRefreshHeader(collectionView) {[unowned self] in
            self.reactor?.action.onNext(.refresh)
        }
        
        reactor?.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
        
    }
    
    func bind(reactor: LiveAllViewReactor) {
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        self.rx.viewDidLoad
            .map{Reactor.Action.refresh}
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
    }
}



extension LiveAllViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: kScreenWidth/2, height: kLiveItemHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}


enum LiveAllViewSection {
    case all([LiveAllViewSectionItem])
}

enum LiveAllViewSectionItem {
    case av(LiveAvCellReactor)
    case roundRoom(LiveRoundRoomCellReactor)
}

extension LiveAllViewSection: SectionModelType {
    
    var items:[LiveAllViewSectionItem] {
        switch self {
        case .all(let items): return items
        }
    }
    
    init(original: LiveAllViewSection, items: [LiveAllViewSectionItem]) {
        switch original {
        case .all : self = .all(items)
        }
    }
}


