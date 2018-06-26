//
//  TogetherSectionDelegate.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReusableKit
import SectionReactor



final class TogetherSectionDelegate: SectionDelegateType {

    typealias SectionReactor = TogetherSectionReactor
    
    private struct Reusable {
      static let avCell = ReusableCell<TogetherAvCell>()
      static let liveCell = ReusableCell<TogetherLiveCell>()
      static let articleCell = ReusableCell<TogetherArticleCell>()
      static let adCell = ReusableCell<TogetherAdCell>()
      static let tipCell = ReusableCell<TogetherTipCell>()
      static let bannerCell = ReusableCell<TogetherBannerCell>()
      static let specialCell = ReusableCell<TogetherSpecialCell>()
    }
    
    func registerReusables(to collectionView: UICollectionView) {
        collectionView.register(Reusable.avCell)
        collectionView.register(Reusable.adCell)
        collectionView.register(Reusable.tipCell)
        collectionView.register(Reusable.bannerCell)
        collectionView.register(Reusable.liveCell)
        collectionView.register(Reusable.articleCell)
        collectionView.register(Reusable.specialCell)
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
        case let .ad(cellReactor):
           let cell = collectionView.dequeue(Reusable.adCell, for: indexPath)
           if cell.reactor !== cellReactor {
            cell.reactor = cellReactor
           }
           return cell
        case let .live(cellReactor):
            let cell = collectionView.dequeue(Reusable.liveCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case let .article(cellReactor):
            let cell = collectionView.dequeue(Reusable.articleCell, for: indexPath)
            if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
            }
            return cell
        case .tip:
           let cell = collectionView.dequeue(Reusable.tipCell, for: indexPath)
           return cell
        case let .banner(cellReactor):
           let cell = collectionView.dequeue(Reusable.bannerCell, for: indexPath)
           if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
           }
           return cell
        case let .special(cellReactor):
           let cell = collectionView.dequeue(Reusable.specialCell, for: indexPath)
           if cell.reactor !== cellReactor {
                cell.reactor = cellReactor
           }
           return cell
        }
    }
    
    func cellSize(
        collectionView: UICollectionView,
        indexPath: IndexPath,
        sectionItem: SectionItem
        ) -> CGSize {
        
        switch sectionItem {
        case .ad(let cellReactor):
            return cellReactor.currentState.cellSize
        case .av(let cellReactor):
            return cellReactor.currentState.cellSize
        case .live(let cellReactor):
            return cellReactor.currentState.cellSize
        case .article(let cellReactor):
            return cellReactor.currentState.cellSize
        case .special(let cellReactor):
            return cellReactor.currentState.cellSize
        case .banner(let cellReactor):
            return cellReactor.currentState.cellSize
        case .tip:
            return CGSize(width: kScreenWidth-2*kCollectionItemPadding, height: kTipCellHeight)
        }
    }
}
