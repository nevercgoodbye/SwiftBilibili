//
//  DramaRcmdCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

import RxSwift

final class DramaRcmdCellReactor: Reactor {

    enum Action {
        case follow(season_id:String,season_type:String)
        case unFollow(season_id:String,season_type:String)
    }
    
    struct State {
        var coverURL: URL?
        var favourites: String?
        var badge: String?
        var title: String
        var latestUpdate: String
        var latestUpdateColor: UIColor
        var watchProgress: String?
        var tagDesc: String?
        var season_id:String?
        var season_type:String?
        var isRcmd: Bool
        var isHiddenLine: Bool
    }
    
    let initialState: State
    
    private let service: HomeServiceType
    
    init(recommend: DramaRecommendModel,service: HomeServiceType,isLast:Bool) {
        
        self.service = service
        
        let coverURL = URL(string: recommend.cover)
        let favourites = "\(recommend.favorites ?? "")人追番"
        let latestUpdate = "更新至第\(recommend.newest_ep_index)话"
        var tagDesc: String = ""
        if let tags = recommend.tags {
            for tag in tags {
               tagDesc += ",\(tag.tag_name)"
            }
        }
        
        if !tagDesc.isEmpty {
            tagDesc.remove(at: String.Index(encodedOffset: 0))
        }
        self.initialState = State(coverURL: coverURL,
                                  favourites: favourites,
                                  badge: recommend.badge,
                                  title: recommend.title,
                                  latestUpdate: latestUpdate,
                                  latestUpdateColor:UIColor.db_pink,
                                  watchProgress: nil,
                                  tagDesc: tagDesc,
                                  season_id:recommend.season_id!,
                                  season_type:"\(recommend.season_type!)",
                                  isRcmd:true,
                                  isHiddenLine: false)
        _ = self.state
    }
    
    init(like: DramaLikeModel,service: HomeServiceType,isLast:Bool) {
        
        self.service = service
        
        let coverURL = URL(string: like.cover)
        let latestUpdate = "更新至第\(like.newest_ep_index)话"
        var watchProgress: String?
        if like.user_season.last_ep_index.isEmpty {
            watchProgress = "尚未观看"
        }else{
            if let num = Int(like.user_season.last_ep_index) {
                watchProgress = "看到第\(num)话"
            }else{
                watchProgress = "看到\(like.user_season.last_ep_index)"
            }
        }
        
        self.initialState = State(coverURL: coverURL,
                                  favourites: nil,
                                  badge: like.badge,
                                  title: like.title,
                                  latestUpdate: latestUpdate,
                                  latestUpdateColor:UIColor.db_darkGray,
                                  watchProgress:watchProgress,
                                  tagDesc: nil,
                                  season_id:nil,
                                  season_type:nil,
                                  isRcmd:false,
                                  isHiddenLine: isLast)
        _ = self.state
    }
    //只需调用接口,其他不用处理
    func mutate(action: Action) -> Observable<Void> {
        switch action {
        case .follow(let season_id, let season_type):
            
            BilibiliToaster.show("由于接口加密,所以需要看到类似B站的效果必须用自己手机抓包,将请求参数替换")
            
           _ = service.dramaFollow(season_id: season_id, season_type: season_type).asObservable().subscribe()
            return .empty()
        case .unFollow(let season_id, let season_type):
           _ = service.dramaUnFollow(season_id: season_id, season_type: season_type).subscribe()
            return .empty()
        }
    }
}
