//
//  DramaVerticalCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class DramaVerticalCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var favourites: String?
        var badge: String?
        var title: String
        var latestUpdate: String
        var watchProgress: String?
        var latestUpdateColor: UIColor
    }
    
    let initialState: State
    
    init(recommend: DramaRecommendModel) {
        
        let coverURL = URL(string: recommend.cover)
        let favourites = "\(recommend.favourites ?? "")人追番"
        let latestUpdate = "更新至第\(recommend.newest_ep_index)话"
        
        self.initialState = State(coverURL: coverURL,
                                  favourites: favourites,
                                  badge: recommend.badge,
                                  title: recommend.title,
                                  latestUpdate: latestUpdate,
                                  watchProgress: nil,
                                  latestUpdateColor: UIColor.db_lightGray)
        _ = self.state
    }
    
    init(follow: DramaFollowModel) {
        
        let coverURL = URL(string: follow.cover)
        let latestUpdate = "更新至第\(follow.newest_ep_index)话"
        
        var watchProgress: String?
        
        if follow.user_season.last_ep_index.isEmpty {
            watchProgress = "尚未观看"
        }else{
            if let num = Int(follow.user_season.last_ep_index) {
                 watchProgress = "看到第\(num)话"
            }else{
                 watchProgress = "看到\(follow.user_season.last_ep_index)"
            }
        }
        
        self.initialState = State(coverURL: coverURL,
                                  favourites: nil,
                                  badge: nil,
                                  title: follow.title,
                                  latestUpdate: latestUpdate,
                                  watchProgress: watchProgress,
                                  latestUpdateColor: UIColor.db_pink)
        _ = self.state
    }
}
