//
//  TogetherViewSection.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxDataSources

enum TogetherViewSection {
    
    case together([TogetherViewSectionItem])
}

extension TogetherViewSection: SectionModelType {
    
    var items: [TogetherViewSectionItem] {
        switch self {
        case let .together(items): return items
        }
    }
    
    init(original: TogetherViewSection, items: [TogetherViewSectionItem]) {
        switch original {
        case .together:self = .together(items)
        }
    }
}

enum TogetherViewSectionItem {
    
    case together(TogetherSectionReactor.SectionItem)
}
