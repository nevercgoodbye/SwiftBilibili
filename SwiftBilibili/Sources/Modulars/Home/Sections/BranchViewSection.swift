//
//  BranchViewSection.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxDataSources

struct BranchViewSection {
    var header:BranchItemModel?
    var items: [BranchViewSectionItem]
}

enum BranchViewSectionItem {
    case branch(BranchSectionReactor.SectionItem)
}

extension BranchViewSection: SectionModelType {
    
    init(original: BranchViewSection, items: [BranchViewSectionItem]) {
        
        self = original
        
        self.items = items
    }
    
}
