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
        var leftMargin:CGFloat
        var rightMargin:CGFloat
    }
    
    let initialState: State
    
    init(recommend: DramaItemModel) {
        
        let coverURL = URL(string: recommend.cover ?? "")
        let favourites = "\(recommend.stat?.follow ?? "")人追番"
        let latestUpdate = recommend.desc ?? ""
        var leftMargin = 0.f,rightMargin = 0.f
        switch recommend.position {
        case .left:
            leftMargin = kCollectionItemPadding
            rightMargin = kCollectionItemPadding/2
        case .middle:
            leftMargin = kCollectionItemPadding/2
            rightMargin = kCollectionItemPadding/2
        case .right:
            leftMargin = kCollectionItemPadding/2
            rightMargin = kCollectionItemPadding
        }
        
        self.initialState = State(coverURL: coverURL,
                                  favourites: favourites,
                                  badge: recommend.badge,
                                  title: recommend.title ?? "",
                                  latestUpdate: latestUpdate,
                                  watchProgress: nil,
                                  latestUpdateColor: UIColor.db_lightGray,
                                  leftMargin:leftMargin,
                                  rightMargin:rightMargin)
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
        
        var leftMargin = 0.f,rightMargin = 0.f
        switch follow.position {
        case .left:
            leftMargin = kCollectionItemPadding
            rightMargin = kCollectionItemPadding/2
        case .middle:
            leftMargin = kCollectionItemPadding/2
            rightMargin = kCollectionItemPadding/2
        case .right:
            leftMargin = kCollectionItemPadding/2
            rightMargin = kCollectionItemPadding
        }
        
        self.initialState = State(coverURL: coverURL,
                                  favourites: nil,
                                  badge: nil,
                                  title: follow.title,
                                  latestUpdate: latestUpdate,
                                  watchProgress: watchProgress,
                                  latestUpdateColor: UIColor.db_pink,
                                  leftMargin:leftMargin,
                                  rightMargin:rightMargin)
        _ = self.state
    }
}
