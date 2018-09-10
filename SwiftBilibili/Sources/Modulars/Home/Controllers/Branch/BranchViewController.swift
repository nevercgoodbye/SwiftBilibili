//
//  BranchViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxDataSources

final class BranchViewController: BaseCollectionViewController,View {

    private let topImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: 180))
    private let dataSource: RxCollectionViewSectionedReloadDataSource<BranchViewSection>
    private let branchSectionDelegate: BranchSectionDelegate
    
    private var currentId: Int = 0
    
    init(reactor:BranchViewReactor,
         branchSectionDelegateFactory: () -> BranchSectionDelegate
        ) {
        defer { self.reactor = reactor }
        self.branchSectionDelegate = branchSectionDelegateFactory()
        self.dataSource = type(of: self).dataSourceFactory(branchSectionDelegate: self.branchSectionDelegate)
        super.init()
        self.branchSectionDelegate.registerReusables(to: collectionView)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private static func dataSourceFactory(
        branchSectionDelegate:BranchSectionDelegate)
        -> RxCollectionViewSectionedReloadDataSource<BranchViewSection> {
            
            return .init(
                configureCell: { (dataSource, collectionView, indexPath, sectionItem) -> UICollectionViewCell in
                    switch sectionItem {
                    case let .branch(sectionItem):
                        return branchSectionDelegate.configureCell(collectionView: collectionView, indexPath: indexPath, sectionItem: sectionItem)
                    }
            }, configureSupplementaryView: { dataSource, collectionView, kind, indexPath in
                
                let section = dataSource[indexPath.section]
                
                return branchSectionDelegate.supplementaryView(collectionView: collectionView, indexPath: indexPath,section:section, kind: kind)
            }
         )
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.collectionView.enableDirection = true
        
        setupRefreshHeader(collectionView) {[unowned self] in

            self.reactor?.action.onNext(.refresh(id: self.currentId, pullDown: true))
        }
        
        reactor?.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
    }
    
    func bind(reactor: BranchViewReactor) {
        
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        
        reactor.state.map{$0.branchModel}
            .filterNil()
            .subscribe(onNext: {[weak self] (branchModel) in
             guard let `self` = self else { return }
             self.hideLoadAnimation()
             self.topImageView.setImage(with: URL(string: branchModel.cover))
             
             if self.collectionView.subviews.contains(self.topImageView) { return }
             DispatchQueue.delay(time: 0.1, action: {
                self.collectionView.addSubview(self.topImageView)
                self.collectionView.sendSubview(toBack: self.topImageView)
             })
        })
            .disposed(by: disposeBag)
        
        reactor.state.map{$0.sections}
            .filterNil()
            .bind(to: collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected(dataSource: dataSource)
            .subscribe(onNext: { (sectionItem) in
            
                switch sectionItem {
                case .branch(let item):
                    switch item {
                    case .special(let cellReactor):
                      BilibiliRouter.push(cellReactor.item.uri ?? "")
                    case .av(_):
                      BilibiliRouter.push(BilibiliPushType.recommend_player)
                    default: break
                    }
                }
        })
            .disposed(by: disposeBag)
    }
    
    func setId(id:Int) {
        self.currentId = id
        reactor?.action.onNext(.refresh(id: id,pullDown:false))
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension BranchViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
            let inset = section == 0 ? 120.f : 0.f
        
            return  UIEdgeInsets(top: inset, left: kCollectionItemPadding, bottom: kCollectionItemPadding, right: kCollectionItemPadding)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let sectionItem = dataSource[indexPath]
        
        switch sectionItem {
        case let .branch(item):
            return self.branchSectionDelegate.cellSize(collectionView: collectionView,indexPath: indexPath, sectionItem: item)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return kCollectionItemPadding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return branchSectionDelegate.headerSize(collectionView: collectionView,section: dataSource[section])
    }
    
}
