//
//  BranchEntranceCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/9/7.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class BranchEntranceCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var items: [BranchAvModel]
    }

    let initialState: State
    
    init(items: [BranchAvModel]) {
        self.initialState = State(items: items)
        _ = self.state
    }
}
