//
//  LiveListViewSection.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxDataSources

struct LiveListViewSection {
    var banners: [LiveListBannerModel]?
    var header: LivePartitionHeaderModel?
    var starShows: [LiveStarShowModel]?
    var items: [LiveListViewSectionItem]
    
    init(items: [LiveListViewSectionItem],banners: [LiveListBannerModel]? = nil,header: LivePartitionHeaderModel? = nil,starShows: [LiveStarShowModel]? = nil) {
        
        self.banners = banners
        
        self.header = header
        
        self.starShows = starShows
        
        self.items = items
    }
    
}

extension LiveListViewSection: SectionModelType {
    
    init(original: LiveListViewSection, items: [LiveListViewSectionItem]) {
        
        self = original
        
        self.items = items
    }
}

enum LiveListViewSectionItem {
  case live(LiveListSectionReactor.SectionItem)
}

