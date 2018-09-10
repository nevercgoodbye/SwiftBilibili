//
//  LiveListViewSection.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxDataSources

enum LiveListViewSection {
    case live(LiveListSectionReactor)
}

extension LiveListViewSection: SectionModelType {

    var items: [LiveListViewSectionItem] {
        switch self {
        case let .live(sectionReactor):
            return sectionReactor.currentState.sectionItems.map{LiveListViewSectionItem.liveElement(sectionReactor, $0)}
        }
    }
    
    init(original: LiveListViewSection, items: [LiveListViewSectionItem]) {
        self = original 
    }
}

enum LiveListViewSectionItem {
    case liveElement(LiveListSectionReactor, LiveListSectionReactor.SectionItem)
}

