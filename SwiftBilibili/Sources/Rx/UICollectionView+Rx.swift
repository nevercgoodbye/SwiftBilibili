//
//  UICollectionView+Rx.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/20.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxCocoa
import RxDataSources
import RxSwift

extension Reactive where Base: UICollectionView {
    func itemSelected<S>(dataSource: CollectionViewSectionedDataSource<S>) -> ControlEvent<S.Item> {
        let source = self.itemSelected.map { indexPath in
            dataSource[indexPath]
        }
        return ControlEvent(events: source)
    }
}
