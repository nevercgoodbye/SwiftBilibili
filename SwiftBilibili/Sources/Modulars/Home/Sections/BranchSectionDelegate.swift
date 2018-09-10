//
//  BranchSectionDelegate.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReusableKit
import SectionReactor

final class BranchSectionDelegate: SectionDelegateType {
    
    typealias SectionReactor = BranchSectionReactor
    
    private struct Reusable {
        static let specialCell = ReusableCell<BranchSpecialCell>()
        static let bannerCell = ReusableCell<TogetherBannerCell>()
        static let entranceCell = ReusableCell<BranchEntranceCell>()
        static let avCell = ReusableCell<TogetherAvCell>()
        static let playerCell = ReusableCell<BranchPlayerCell>()
        static let headerView = ReusableView<BranchHeaderView>()
    }
    
    func registerReusables(to collectionView: UICollectionView) {
        collectionView.register(Reusable.specialCell)
        collectionView.register(Reusable.bannerCell)
        collectionView.register(Reusable.entranceCell)
        collectionView.register(Reusable.avCell)
        collectionView.register(Reusable.playerCell)
        collectionView.register(Reusable.headerView, kind: UICollectionElementKindSectionHeader)
    }
    
    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        sectionItem: SectionItem
        ) -> UICollectionViewCell {
        
        switch sectionItem {
        case .banner(let cellReactor):
            let cell = collectionView.dequeue(Reusable.bannerCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case .entrance(let cellReactor):
            let cell = collectionView.dequeue(Reusable.entranceCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case .av(let cellReactor):
            let cell = collectionView.dequeue(Reusable.avCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case .special(let cellReactor):
            let cell = collectionView.dequeue(Reusable.specialCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case .player(let cellReactor):
            let cell = collectionView.dequeue(Reusable.playerCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        }
    }
    
    func supplementaryView(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        section: BranchViewSection,
        kind:String
        ) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let view = collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
            view.reloadData(headerModel: section.header)
            return view
        default:
            return collectionView.emptyView(for: indexPath, kind: kind)
        }
    }
    
    func cellSize(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        sectionItem: SectionItem
        ) -> CGSize {
        
        switch sectionItem {
        case .banner:
            return CGSize(width: kScreenWidth - 2*kCollectionItemPadding, height: kBannerHeight)
        case .special(let cellReactor):
            return Reusable.specialCell.class.size(reactor: cellReactor)
        case .av:
            return CGSize(width: (kScreenWidth - 3*kCollectionItemPadding)/2, height: kNormalItemHeight)
        case .entrance:
            return CGSize(width: kScreenWidth - 2*kCollectionItemPadding, height: 50)
        case .player(let cellReactor):
            return Reusable.playerCell.class.size(reactor: cellReactor)
        }
    }
    
    func headerSize(
        collectionView: UICollectionView,
        section: BranchViewSection
        ) -> CGSize {
        
        guard let type = section.header?.goto else {
            return .zero
        }
        
        if type == .content_rcmd || type == .tag_rcmd {
            if let item = section.header?.item {
               let count = item.filter{$0.goto == .av}.count
                if count < 2 { return .zero }
            }
            return CGSize(width: kScreenWidth, height: 40)
        }else{
            return .zero
        }
    }

    
    
}
