//
//  HomeEnum.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/22.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

enum TogetherDataType : String {
    case ad_s = "ad_web_s"
    case ad = "ad_web"
    case ad_av = "ad_av"
    case ad_large = "ad_large"
    case login = "login"
    case rank = "rank"
    case av = "av"
    case article = "article_s"
    case banner = "banner"
    case bangumi = "bangumi"
    case live = "live"
    case audio = "audio"
    case special_s = "special_s"
    case shopping_s = "shopping_s"
    case converge = "converge"
}

enum TogetherRefreshType {
    case none
    case pullRefresh
    case loadMore
}

enum TogetherDislikeType: Int {
    case up = 4
    case zone = 2
    case remark = 3
    case noInterest = 1
}

enum LivePartitionType: Int {
    case recommend
    case entertainment
    case PCGame
    case mobileGame
    case draw
    case attention = 666
    case beauty = 999
}

extension LivePartitionType {
    
    var title: String {
        switch self {
        case .recommend:
            return "推荐"
        case .entertainment:
            return "娱乐"
        case .PCGame:
            return "游戏"
        case .mobileGame:
            return "手游"
        case .draw:
            return "绘画"
        case .beauty:
            return "颜值"
        case .attention:
            return "关注"
        }
    }
}

enum LiveAllSubType: String {
    case suggestion = "推荐直播"
    case hottest = "最热直播"
    case latest = "最新开播"
    case roundroom = "视频轮播"
}

extension LiveAllSubType {
    
    var title: String {
        switch self {
        case .suggestion:
            return "suggestion"
        case .hottest:
            return "hottest"
        case .latest:
            return "latest"
        case .roundroom:
            return "roundroom"
        }
    }
}

enum DramaSectionType: Int {
    case mine
    case drama
    case country
    case review
    case edit
}

extension DramaSectionType {
    
    var title: String {
        switch self {
        case .mine:
            return "我的追番"
        case .drama:
            return "番剧推荐"
        case .country:
            return "国产动画推荐"
        case .review:
            return "点评推荐"
        case .edit:
            return "编辑推荐"
        }
    }
}

enum RankRegionType:Int {
    
    case wholeStation = 999999
    case country = 167
    case drama = 13
    case animation = 1
    case music = 3
    case dance = 129
    case game = 4
    case technology = 36
    case life = 160
    case ghost = 119
    case fashion = 155
    case entertainment = 5
    case movie = 181
    case recoder = 177
    case film = 23
    case tv = 11
}

extension RankRegionType {
    
    var title: String {
        switch self {
        case .wholeStation:
            return "全站"
        case .country:
            return "国创"
        case .drama:
            return "追番"
        case .animation:
            return "动画"
        case .dance:
            return "舞蹈"
        case .entertainment:
            return "娱乐"
        case .fashion:
            return "时尚"
        case .film:
            return "电影"
        case .game:
            return "游戏"
        case .ghost:
            return "鬼畜"
        case .life:
            return "生活"
        case .movie:
            return "影视"
        case .music:
            return "音乐"
        case .recoder:
            return "纪录片"
        case .technology:
            return "科技"
        case .tv:
            return "电视剧"
        }
    }
}



