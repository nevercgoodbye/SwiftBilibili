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
    
    fileprivate struct Reusable {
        static let avCell = ReusableCell<LiveAvCell>()
        static let bannerCell = ReusableCell<LiveBannerCell>()
        static let beautyCell = ReusableCell<LiveBeautyCell>()
        static let footerView = ReusableView<LiveListFooterView>(nibName:"LiveListFooterView")
        static let headerView = ReusableView<LiveListHeaderView>()
    }
    
    func registerReusables(to collectionView: UICollectionView) {
        collectionView.register(Reusable.avCell)
        collectionView.register(Reusable.bannerCell)
        collectionView.register(Reusable.beautyCell)
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
        case let .banner(cellReactor):
            let cell = collectionView.dequeue(Reusable.bannerCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case let .beauty(cellReactor):
            let cell = collectionView.dequeue(Reusable.beautyCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        }
    }
    
    func supplementaryView(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        section:LiveListViewSection,
        sectionCount:Int,
        kind:String
        ) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionFooter:
            let view = collectionView.dequeue(Reusable.footerView, kind: kind, for: indexPath)
            view.partitionType = section.header?.partitionType
            view.allLiveView.isHidden = indexPath.section != sectionCount - 1
            return view
        case UICollectionElementKindSectionHeader:
            let view = collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
            view.reloadData(headerModel:section.header,bannerModels:section.banners,starShows:section.starShows)
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
        case .av,.beauty:
            return CGSize(width: (kScreenWidth - 3*kCollectionItemPadding)/2, height: kLiveItemHeight)
        case let .banner(cellReactor):
            return Reusable.bannerCell.class.size(width: kScreenWidth - 2*kCollectionItemPadding, reactor: cellReactor)
        }
    }
    
    func footerSize(
        collectionView: UICollectionView,
        section: Int,
        viewSection: LiveListViewSection,
        sectionCount:Int
        ) -> CGSize {
        
        guard let _ = viewSection.header?.partitionType else {
            return .zero
        }

        if section == sectionCount - 1 {
            return CGSize(width: kScreenWidth, height: 140)
        }
        return CGSize(width: kScreenWidth, height: 60)
    }
    
    func headerSize(
        collectionView: UICollectionView,
        section: Int,
        viewSection: LiveListViewSection,
        isShowStar: Bool
        ) -> CGSize {
        
        guard let _ = viewSection.header?.partitionType else {
            return .zero
        }
        
        if section == 0 {
            return isShowStar ? CGSize(width: kScreenWidth, height: 400) : CGSize(width: kScreenWidth, height: 180)
        }
        return CGSize(width: kScreenWidth, height: 40)
    }
    
}
