//
//  BranchPlayerCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class BranchPlayerCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String
    }
    
    let initialState: State
    
    let av: BranchAvModel
    
    init(av: BranchAvModel) {
        
        self.av = av
        
        let coverURL = URL(string: av.cover ?? "")
        
        self.initialState = State(coverURL: coverURL,
                                  title: av.title ?? "")
        _ = self.state
    }
}
