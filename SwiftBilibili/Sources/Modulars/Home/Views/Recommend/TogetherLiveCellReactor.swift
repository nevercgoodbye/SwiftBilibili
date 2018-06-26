//
//  TogetherLiveCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/7.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class TogetherLiveCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String?
        var desc: String?
        var anchorName: String?
        var online: String?
        var cellSize: CGSize
    }
    
    let initialState: State
    
    let together: RecommendTogetherModel
    
    init(together: RecommendTogetherModel) {
        
        self.together = together
        
        let coverURL = URL(string: together.cover ?? "")
        let desc = together.area2?.children.name
        
        self.initialState = State(coverURL: coverURL,
                                  title: together.title,
                                  desc: desc,
                                  anchorName: together.name,
                                  online:together.online,
                                  cellSize:CGSize(width: (kScreenWidth - 3*kCollectionItemPadding)/2, height: kNormalItemHeight))
        _ = self.state
    }
    

}
