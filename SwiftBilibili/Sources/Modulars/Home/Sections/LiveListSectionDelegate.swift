//
//  LiveListSectionDelegate.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/27.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReusableKit
import SectionReactor

final class LiveListSectionDelegate: SectionDelegateType {

    typealias SectionReactor = LiveListSectionReactor
    
    private struct Reusable {
        static let avCell = ReusableCell<LiveAvCell>()
        static let hourRankCell = ReusableCell<LiveHourRankCell>()
        static let footerView = ReusableView<LiveListFooterView>(nibName:"LiveListFooterView")
        static let headerView = ReusableView<LiveListHeaderView>()
    }
    
    func registerReusables(to collectionView: UICollectionView) {
        collectionView.register(Reusable.avCell)
        collectionView.register(Reusable.hourRankCell)
        collectionView.register(Reusable.footerView, kind: UICollectionElementKindSectionFooter)
        collectionView.register(Reusable.headerView, kind: UICollectionElementKindSectionHeader)
    }
    
    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        sectionItem: SectionItem
        ) -> UICollectionViewCell {
        
        switch sectionItem {
        case let .av(cellReactor):
            let cell = collectionView.dequeue(Reusable.avCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case .hourRank:
            let cell = collectionView.dequeue(Reusable.hourRankCell, for: indexPath)
            return cell
        }
    }
    
    func supplementaryView(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        sectionReactor:SectionReactor,
        totalCount:Int,
        kind:String
        ) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            let view = collectionView.dequeue(Reusable.footerView, kind: kind, for: indexPath)
            view.reloadData(headerModel:sectionReactor.currentState.module.module_info)
            view.allLiveView.isHidden = indexPath.section != totalCount - 1
            return view
        case UICollectionElementKindSectionHeader:
            let view = collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
            view.reloadData(headerModel:sectionReactor.currentState.module.module_info,bannerModels:sectionReactor.bannerModels, regionModels: sectionReactor.regionModels, tagModels: sectionReactor.tagModels ?? [])
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
         case .av:
            return CGSize(width: kScreenWidth/2, height: kLiveItemHeight)
         case .hourRank:
            return CGSize(width: kScreenWidth, height: kLiveItemHeight)
        }
    }
    
    func footerSize(
         collectionView: UICollectionView,
         section: Int,
         sectionReactor:SectionReactor,
         totalCount:Int
         ) -> CGSize {
        
        if sectionReactor.currentState.module.module_info.id == hourRankModuleId {
            return .zero
        }
        
         if section == totalCount - 1 {
            return CGSize(width: kScreenWidth, height: 160)
         }
         return CGSize(width: kScreenWidth, height: 50)
    }
    
    func headerSize(
         collectionView: UICollectionView,
         section: Int,
         viewSection: LiveListViewSection
         ) -> CGSize {
        
         if section == 0 {
            return CGSize(width: kScreenWidth, height: 340)
         }
         return CGSize(width: kScreenWidth, height: 40)
    }
    
}
