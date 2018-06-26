//
//  LiveBannerCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class LiveBannerCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var coverHeight: CGFloat
        var title: String
    }
    
    let initialState: State
    
    init(banner: LiveRecommendBannerModel) {
        
        let coverURL = URL(string: banner.new_cover.src ?? "")
        
        self.initialState = State(coverURL: coverURL,
                                  coverHeight: banner.cover.height.f,
                                  title: banner.title)
        _ = self.state
    }
}
