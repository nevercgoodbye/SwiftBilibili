//
//  TogetherSpecialCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/8.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class TogetherSpecialCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String?
        var desc: String?
        var badge: String?
        var badgeSize: CGSize
        var cellSize: CGSize
    }
    
    let initialState: State
    
    let together: RecommendTogetherModel
    
    init(together: RecommendTogetherModel) {
        
        self.together = together
        
        let coverURL = URL(string: together.cover ?? "")
        
        let desc = together.desc
        
        let badgeSize = (together.badge ?? "").size(thatFits: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude), font: Font.SysFont.sys_11)
        
        self.initialState = State(coverURL: coverURL,
                                  title: together.title,
                                  desc: desc,
                                  badge:together.badge,
                                  badgeSize:badgeSize,
                                  cellSize:CGSize(width: (kScreenWidth - 3*kCollectionItemPadding)/2, height: kNormalItemHeight))
        _ = self.state
    }
    
    
}
