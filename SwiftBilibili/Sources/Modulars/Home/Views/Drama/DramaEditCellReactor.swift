//
//  DramaEditCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class DramaEditCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String
        var des: String?
        var isNew: Bool
    }
    
    let initialState: State
    
    let foot: DramaFootModel
    
    init(foot: DramaFootModel) {
        
        self.foot = foot
        
        let coverURL = URL(string: foot.cover)
        
        var isNew = false
        
        if let is_new = foot.is_new {
            isNew = is_new > 0
        }
        
        self.initialState = State(coverURL: coverURL,
                                  title: foot.title,
                                  des: foot.desc,
                                  isNew:isNew)
        _ = self.state
    }
}
