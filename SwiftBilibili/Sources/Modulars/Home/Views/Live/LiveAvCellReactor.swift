//
//  LiveAvCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class LiveAvCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var anchorName: String
        var liveTitle: String
        var online: String
        var category: String
//        var leftMargin: CGFloat
//        var rightMargin: CGFloat
    }
    
    let initialState: State
    
    let live: LiveAvModel
    
    init(live: LiveAvModel) {
        
        self.live = live
        
        let coverURL = URL(string: live.cover ?? "")
        
//        let leftMargin = live.isLeft ? kCollectionItemPadding : kCollectionItemPadding * 0.5
//        let rightMargin = live.isLeft ? kCollectionItemPadding * 0.5 : kCollectionItemPadding
        
        self.initialState = State(coverURL: coverURL,
                                  anchorName: live.uname ?? "",
                                  liveTitle: live.title ?? "",
                                  online: live.online ?? "",
                                  category: live.area_v2_name ?? "")
        _ = self.state
    }
}
