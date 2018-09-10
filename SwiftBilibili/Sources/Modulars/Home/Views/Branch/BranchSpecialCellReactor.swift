//
//  BranchSpecialCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class BranchSpecialCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String
        var badge: String?
        var desc: String
    }
    
    let initialState: State
    
    let item: BranchItemModel
    
    init(item: BranchItemModel) {
        
        self.item = item
        
        let coverURL = URL(string: item.cover ?? "")
        
        self.initialState = State(coverURL: coverURL,
                                  title: item.title ?? "",
                                  badge: item.badge,
                                  desc: item.desc ?? "")
        _ = self.state
    }
    
    
}
