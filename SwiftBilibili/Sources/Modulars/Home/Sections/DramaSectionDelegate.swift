//
//  DramaSectionDelegate.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReusableKit
import SectionReactor

final class DramaSectionDelegate: SectionDelegateType {

    typealias SectionReactor = DramaSectionReactor
    
    fileprivate struct Reusable {
        static let editCell = ReusableCell<DramaEditCell>()
        static let reviewCell = ReusableCell<DramaReviewCell>()
        static let verticalCell = ReusableCell<DramaVerticalCell>()
        static let headerView = ReusableView<DramaHeaderView>()
    }
    
    func registerReusables(to collectionView: UICollectionView) {
        collectionView.register(Reusable.editCell)
        collectionView.register(Reusable.reviewCell)
        collectionView.register(Reusable.verticalCell)
        collectionView.register(Reusable.headerView, kind: UICollectionElementKindSectionHeader)
    }
    
    func configureCell(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        sectionItem: SectionItem
        ) -> UICollectionViewCell {
        
        switch sectionItem {
        case let .edit(cellReactor):
            let cell = collectionView.dequeue(Reusable.editCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case let .review(cellReactor):
            let cell = collectionView.dequeue(Reusable.reviewCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case let .vertical(cellReactor):
            let cell = collectionView.dequeue(Reusable.verticalCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        }
    }
    
    func supplementaryView(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        section: DramaViewSection,
        sectionCount: Int,
        kind:String
        ) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let view = collectionView.dequeue(Reusable.headerView, kind: kind, for: indexPath)
            view.reloadData(headerModel: section.headerModel,sectionCount:sectionCount)
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
        case .edit(let cellReactor):
            return Reusable.editCell.class.size(reactor: cellReactor)
        case .review(let cellReactor):
            return Reusable.reviewCell.class.size(reactor: cellReactor)
        case .vertical(let cellReactor):
            return Reusable.verticalCell.class.size(reactor: cellReactor)
        }
    }
    
    func headerSize(
        collectionView: UICollectionView,
        section: DramaViewSection,
        sectionCount: Int
        ) -> CGSize {
        
        let type = section.headerModel!.type
        
        var height = 75.f
        
        if type == .edit {
            height = 60
        }else if type == .drama {
            if sectionCount == 5 {
                height = 75
            }else{
                height = 330
            }
        }else if type == .mine {
            height = 190
        }
        
        return CGSize(width: kScreenWidth, height: height)
    }
    
}
