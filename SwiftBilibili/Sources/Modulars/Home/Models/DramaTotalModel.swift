//
//  DramaTotalModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper

struct DramaMineModel: ImmutableMappable {
    
    var follow_count: Int
    var update_count: Int
    var follows: [DramaFollowModel]
    
    init(map: Map) throws {
        follow_count = try map.value("follow_count")
        update_count = try map.value("update_count")
        follows = try map.value("follows")
    }
}

struct DramaFollowModel: ImmutableMappable {
    
    var ban_area_show: Int
    var brief: String
    var cover: String
    var ed_jump: Int
    var is_finish: String
    var is_started: Int
    var limitGroupId: Int
    var newest_ep_id: String
    var newest_ep_index: String
    var pub_time: String
    var pub_time_show: String
    var season_id: String
    var season_status: Int
    var squareCover: String
    var title: String
    var url: String
    var vip_quality: Int
    var version: String
    var weekday: String
    var user_season: DramaUserSeasonModel
    
    init(map: Map) throws {
        ban_area_show = try map.value("ban_area_show")
        brief = try map.value("brief")
        cover = try map.value("cover")
        ed_jump = try map.value("ed_jump")
        is_finish = try map.value("is_finish")
        is_started = try map.value("is_started")
        limitGroupId = try map.value("limitGroupId")
        newest_ep_id = try map.value("newest_ep_id")
        newest_ep_index = try map.value("newest_ep_index")
        pub_time = try map.value("pub_time")
        pub_time_show = try map.value("pub_time_show")
        season_id = try map.value("season_id")
        season_status = try map.value("season_status")
        squareCover = try map.value("squareCover")
        title = try map.value("title")
        url = try map.value("url")
        vip_quality = try map.value("vip_quality")
        version = try map.value("version")
        weekday = try map.value("weekday")
        user_season = try map.value("user_season")
    }
}

struct DramaUserSeasonModel: ImmutableMappable {
    
    var attention: String
    var bp: Int
    var last_ep_id: String
    var last_ep_index: String
    var last_time: String
    var report_ts: Int

    init(map: Map) throws {
        attention = try map.value("attention")
        bp = try map.value("bp")
        last_ep_id = try map.value("last_ep_id")
        last_ep_index = try map.value("last_ep_index")
        last_time = try map.value("last_time")
        report_ts = try map.value("report_ts")
    }
    
}

struct DramaPageModel: ModelType {
    
    enum Event {}

    var recommend_cn: DramaCnModel
    var recommend_jp: DramaCnModel
    var recommend_review: [DramaReviewModel]
    var timeline: [DramaTimelineModel]
    
    init(map: Map) throws {
        recommend_cn = try map.value("recommend_cn")
        timeline = try map.value("timeline")
        recommend_review = try map.value("recommend_review")
        recommend_jp = try map.value("recommend_jp")
        
    }
}

struct DramaCnModel: ImmutableMappable {
    var foot: [DramaFootModel]
    var recommend: [DramaRecommendModel]
    
    init(map: Map) throws {
        foot = try map.value("foot")
        recommend = try map.value("recommend")
    }
}

struct DramaFootModel: ImmutableMappable {
    
    var cover: String
    var desc: String?
    var id: Int
    var is_auto: Int?
    var link: String
    var title: String
    var wid: Int
    var type: Int?
    var is_new: Int?
    var cursor: Int?
    
    init(map: Map) throws {
        cover = try map.value("cover")
        desc = try? map.value("desc")
        id = try map.value("id")
        is_auto = try? map.value("is_auto")
        link = try map.value("link")
        title = try map.value("title")
        wid = try map.value("wid")
        type = try? map.value("type")
        is_new = try? map.value("is_new")
        cursor = try? map.value("cursor")
    }
}

struct DramaRecommendModel:ImmutableMappable {
 
    var badge: String?
    var brief: String?
    var cover: String
    var favourites: String?
    var favorites: String?
    var is_auto: Int?
    var is_finish: String?
    var is_started: Int
    var last_time: Int?
    var newest_ep_index: String
    var pub_time: String?
    var season_id: String?
    var season_type: Int?
    var season_status: Int
    var title: String
    var total_count: String?
    var watching_count: Int?
    var wid: Int?
    var tags: [DramaTagModel]?

    
    init(map: Map) throws {
        brief = try? map.value("brief")
        badge = try? map.value("badge")
        cover = try map.value("cover")
        favourites = try? map.value("favourites", using: NumberTransform())
        favorites = try? map.value("favorites", using: NumberTransform())
        is_auto = try? map.value("is_auto")
        is_finish = try? map.value("is_finish", using: TypeTransform())
        is_started = try map.value("is_started")
        last_time = try? map.value("last_time")
        newest_ep_index = try map.value("newest_ep_index")
        pub_time = try? map.value("pub_time", using: TypeTransform())
        season_id = try? map.value("season_id", using: TypeTransform())
        season_status = try map.value("season_status")
        season_type = try? map.value("season_type")
        title = try map.value("title")
        total_count = try? map.value("total_count", using: TypeTransform())
        watching_count = try? map.value("watching_count")
        wid = try? map.value("wid")
        tags = try? map.value("tags")
    }
}

struct DramaLikeModel:ImmutableMappable {
    
    var badge: String?
    var alias: String
    var allow_bp: String
    var allow_download: String
    var area: String
    var arealimit: Int
    var ban_area_show: Int
    var bangumi_id: String
    var bangumi_title: String
    var brief: String
    var coins: String
    var copyright: String
    var cover: String
    var danmaku_count: String
    var ed_jump: Int
    var evaluate: String
    var favorites: String?
    var is_finish: String
    var is_started: Int
    var jp_title: String
    var limitGroupId: Int
    var newest_ep_id: String
    var newest_ep_index: String
    var origin_name: String
    var play_count: String
    var pub_time: String
    var pub_time_show: String
    var season_id: String
    var season_status: Int
    var season_title: String
    var share_url: String
    var squareCover: String
    var tags: [DramaTagModel]
    var title: String
    var url: String
    var user_season: DramaUserSeasonModel

    
    init(map: Map) throws {
        badge = try? map.value("badge")
        alias = try map.value("alias")
        allow_bp = try map.value("allow_bp")
        allow_download = try map.value("allow_download")
        area = try map.value("area")
        arealimit = try map.value("arealimit")
        ban_area_show = try map.value("ban_area_show")
        bangumi_id = try map.value("bangumi_id")
        bangumi_title = try map.value("bangumi_title")
        brief = try map.value("brief")
        coins = try map.value("coins")
        copyright = try map.value("copyright")
        cover = try map.value("cover")
        danmaku_count = try map.value("danmaku_count")
        ed_jump = try map.value("ed_jump")
        evaluate = try map.value("evaluate")
        favorites = try? map.value("favorites", using: NumberTransform())
        is_finish = try map.value("is_finish")
        is_started = try map.value("is_started")
        jp_title = try map.value("jp_title")
        limitGroupId = try map.value("limitGroupId")
        newest_ep_id = try map.value("newest_ep_id")
        newest_ep_index = try map.value("newest_ep_index")
        origin_name = try map.value("origin_name")
        play_count = try map.value("play_count")
        pub_time = try map.value("pub_time")
        pub_time_show = try map.value("pub_time_show")
        season_id = try map.value("season_id")
        season_status = try map.value("season_status")
        season_title = try map.value("season_title")
        share_url = try map.value("share_url")
        squareCover = try map.value("squareCover")
        tags = try map.value("tags")
        title = try map.value("title")
        url = try map.value("url")
        user_season = try map.value("user_season")
    }
}



struct DramaTagModel: ImmutableMappable {
    
    var tag_id: String
    var tag_name: String
    
    init(map: Map) throws {
        tag_id = try map.value("tag_id")
        tag_name = try map.value("tag_name")
    }
}

struct DramaReviewModel: ImmutableMappable {
    var author: DramaAuthorModel
    var content: String
    var ctime: Int
    var likes: String
    var media: DramaMediaModel
    var mtime: Int
    var reply: String
    var review_id: Int
    var title: String
    
    var isShowBottomLine: Bool = true

    init(map: Map) throws {
        author = try map.value("author")
        content = try map.value("content")
        ctime = try map.value("ctime")
        likes = try map.value("likes", using: NumberTransform())
        media = try map.value("media")
        mtime = try map.value("mtime")
        reply = try map.value("reply", using: NumberTransform())
        review_id = try map.value("review_id")
        title = try map.value("title")
    }
}

struct DramaTimelineModel: ImmutableMappable {
    
    var badge: String?
    var area_id: Int
    var cover: String
    var delay: Int
    var ep_id: Int
    var favorites: Int
    var follow: Int
    var is_published: Int
    var order: Int
    var pub_date: String
    var pub_index: String
    var pub_time: String
    var pub_ts: Int
    var season_id: Int
    var season_status: Int
    var square_cover: String
    var title: String

    init(map: Map) throws {
        badge = try? map.value("badge")
        area_id = try map.value("area_id")
        cover = try map.value("cover")
        delay = try map.value("delay")
        ep_id = try map.value("ep_id")
        favorites = try map.value("favorites")
        follow = try map.value("follow")
        is_published = try map.value("is_published")
        order = try map.value("order")
        season_id = try map.value("season_id")
        season_status = try map.value("season_status")
        title = try map.value("title")
        pub_date = try map.value("pub_date")
        pub_index = try map.value("pub_index")
        pub_time = try map.value("pub_time")
        pub_ts = try map.value("pub_ts")
        square_cover = try map.value("square_cover")
        title = try map.value("title")
    }
}

struct DramaAuthorModel: ImmutableMappable {
    var avatar: String
    var mid: Int
    var uname: String
    
    init(map: Map) throws {
        avatar = try map.value("avatar")
        mid = try map.value("mid")
        uname = try map.value("uname")
    }
}

struct DramaMediaModel: ImmutableMappable {
    var cover: String
    var media_id: Int
    var title: String
    
    init(map: Map) throws {
        cover = try map.value("cover")
        media_id = try map.value("media_id")
        title = try map.value("title")
    }
}

struct DramaHeaderModel {
    var icon: UIImage?
    var name: String
    var type: DramaSectionType
    
    init(icon:UIImage?,name:String,type:DramaSectionType) {
        self.icon = icon
        self.name = name
        self.type = type
    }
}



