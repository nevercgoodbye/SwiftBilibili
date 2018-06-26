//
//  TogetherArticleCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/7.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class TogetherArticleCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String?
        var desc: String?
        var play: String?
        var reply: String?
        var cellSize: CGSize
    }
    
    let initialState: State
    
    let together: RecommendTogetherModel
    
    init(together: RecommendTogetherModel) {
        
        self.together = together
        
        let coverURL = URL(string: together.banner_url ?? "")
    
        var desc: String = ""
        
        if let categoryName = together.category?.name {
            desc = "\(categoryName)"
        }
        if let childName = together.category?.children.name {
            desc += " · \(childName)"
        }
        
        self.initialState = State(coverURL: coverURL,
                                  title: together.title,
                                  desc: desc,
                                  play: together.play,
                                  reply:together.reply,
                                  cellSize:CGSize(width: (kScreenWidth - 3*kCollectionItemPadding)/2, height: kNormalItemHeight))
        _ = self.state
    }
    
    
}
