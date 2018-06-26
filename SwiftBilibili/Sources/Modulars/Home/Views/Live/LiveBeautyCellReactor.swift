//
//  LiveBeautyCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/22.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class LiveBeautyCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var anchorName: String
        var online: String
    }
    
    let initialState: State
    
    let live: LivePartitionAvModel
    
    init(live: LivePartitionAvModel) {
        
        self.live = live
        
        let coverURL = URL(string: live.show_cover ?? "")
        
        self.initialState = State(coverURL: coverURL,
                                  anchorName: live.uname,
                                  online: live.online)
        _ = self.state
    }
}
