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
    case article_rcmd = "article_s"
    case article_branch = "article"
    case player = "player"
    case banner = "banner"
    case bangumi = "bangumi"
    case live = "live"
    case audio = "audio"
    case special_s = "special_s"
    case special = "special"
    case shopping_s = "shopping_s"
    case converge = "converge"
    case content_rcmd = "content_rcmd"
    case tag_rcmd = "tag_rcmd"
    case entrance = "entrance"
    case web = "web"
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

enum LiveModuleType: Int {
    case banner = 1
    case region = 2
    case attention = 13
    case recommed = 3
    case hourRank = 4
    case battlegrounds = 22  //绝地求生
    case KingGlory = 24 //王者荣耀
    case PCGame = 5
    case fivePeople = 21 //第五人格
    case mobileGame = 6
    case videoSong = 20 //视频唱见
    case enterment = 7
    case draw = 8
}

extension LiveModuleType {
    var showCount: Int {
        switch self {
        case .recommed:
            return 6
        default:
            return 4
        }
    }
    
}

enum LiveAllSubType: String {
    case hottest = "最热直播"
    case latest = "最新开播"
    case roundroom = "视频轮播"
}

extension LiveAllSubType {
    
    var title: String {
        switch self {
        case .hottest:
            return "hottest"
        case .latest:
            return "latest"
        case .roundroom:
            return "roundroom"
        }
    }
}

enum DramaVerticalPosition: Int {
    case left = 0
    case middle
    case right
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



