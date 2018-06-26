//
//  DramaViewSection.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxDataSources

struct DramaViewSection {
    var headerModel:DramaHeaderModel?
    var items: [DramaViewSectionItem]
}

enum DramaViewSectionItem {
    case drama(DramaSectionReactor.SectionItem)
}

extension DramaViewSection: SectionModelType {
    
    init(original: DramaViewSection, items: [DramaViewSectionItem]) {
        
        self = original
        
        self.items = items
    }
    
}
