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
    }
    
    let initialState: State
    
    let live: LivePartitionAvModel
    
    init(live: LivePartitionAvModel) {
        
        self.live = live
        
        let coverURL = URL(string: live.face)
        
        self.initialState = State(coverURL: coverURL,
                                  anchorName: live.uname,
                                  liveTitle: live.title,
                                  online: live.online,
                                  category: live.area_name)
        _ = self.state
    }
    

}
