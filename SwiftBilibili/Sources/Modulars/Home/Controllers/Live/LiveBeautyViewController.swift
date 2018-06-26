//
//  LiveBeautyViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/23.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources
import ReusableKit

final class LiveBeautyViewController: BaseCollectionViewController,View {

    fileprivate struct Reusable {
        static let beautyCell = ReusableCell<LiveBeautyCell>()
    }
    
    fileprivate let dataSource: RxCollectionViewSectionedReloadDataSource<LiveBeautyViewSection>
    
    
    init(reactor: LiveBeautyViewReactor) {
        defer { self.reactor = reactor }
        
        self.dataSource = .init(
            configureCell: { (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
            switch sectionItem {
            case let .beauty(cellReactor):
              let cell = collectionView.dequeue(Reusable.beautyCell, for: indexPath)
              cell.reactor = cellReactor
              return cell
            }
          })
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "颜值领域"
        
        collectionView.register(Reusable.beautyCell)
        
        setupRefreshHeader(collectionView) {[unowned self] in
            
            self.reactor?.action.onNext(.refresh)
        }
        
        reactor?.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
    }
    
    func bind(reactor: LiveBeautyViewReactor) {
        
        self.rx.viewDidLoad
            .map{Reactor.Action.refresh}
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.sections }
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.sections}
            .subscribe(onNext: {[unowned self] (_) in
                self.hideAnimationView(self.collectionView)
            })
            .disposed(by: disposeBag)
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    
}

extension LiveBeautyViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionItem = dataSource[indexPath]
        
        switch sectionItem {
        case .beauty:
          return CGSize(width: (kScreenWidth - 3*kCollectionItemPadding)/2, height: kLiveItemHeight)
      }
   }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: kCollectionItemPadding, left: kCollectionItemPadding, bottom: kCollectionItemPadding, right: kCollectionItemPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return kCollectionItemPadding
    }
    
}

enum LiveBeautyViewSection {
    case beauty([LiveBeautyViewSectionItem])
}

extension LiveBeautyViewSection: SectionModelType {
    var items: [LiveBeautyViewSectionItem] {
        switch self {
        case .beauty (let items): return items
        }
    }
    
    init(original: LiveBeautyViewSection, items: [LiveBeautyViewSectionItem]) {
        switch original {
        case .beauty: self = .beauty(items)
        }
    }
}

enum LiveBeautyViewSectionItem {
    case beauty(LiveBeautyCellReactor)
}
