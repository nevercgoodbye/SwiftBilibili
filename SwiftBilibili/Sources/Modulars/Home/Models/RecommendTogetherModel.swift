//
//  HomeRecommendModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/16.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit
import ObjectMapper

struct RecommendTogetherModel: ModelType {

    enum Event {
       case cacheTogethers(togethers:[RecommendTogetherModel])
       case dislikeReason(idx:Int?,dislikeModel:TogetherDislikeModel?,isDelete:Bool)
       case watchLater(idx:Int?,isCancle:Bool)
    }
    
    var title: String?
    var cover: String?
    var uri: String?
    var goto: TogetherDataType = .av
    var desc: String?
    var play: String?
    var danmaku: String?
    var reply: String?
    var favourite: Int?
    var coin: Int?
    var share: Int?
    var like: Int?
    var idx: Int?
    var tid: Int?
    var tname:String?
    var tag: TogetherTagModel?
    var dislike_reasons: [TogetherDislikeModel]?
    var ctime: Int?
    var duration: String?
    var mid: Int?
    var name: String?
    var face: String?
    var area: String?
    var area_id: String?
    var area2: TogetherArea2Model?
    var online: String?
    var hash: String?
    var rcmd_reason: TogetherRcmdReasonModel?
    var banner_item: [TogetherBannerModel]?
    var badge: String?
    var hide_badge: Bool?
    var category: TogetherArea2Model?
    var banner_url: String?
    var count: Int?
    var tags: [TogetherTagModel]?
    
    //配合UI使用
    var isShowTip: Bool = false
    var isDislike: Bool = false
    var dislikeName: String?
    var dislikeRecordTime: Date?
    var isSetWatchLater: Bool = false
    
    init(map: Map) throws {
        title = try? map.value("title")
        cover = try? map.value("cover")
        uri = try? map.value("uri")
        goto = try map.value("goto", using: EnumTransform<TogetherDataType>())
        desc = try? map.value("desc")
        play = try? map.value("play", using: NumberTransform())
        danmaku = try? map.value("danmaku", using: NumberTransform())
        reply = try? map.value("reply", using: NumberTransform())
        favourite = try? map.value("favourite")
        coin = try? map.value("coin")
        share = try? map.value("share")
        like = try? map.value("like")
        idx = try map.value("idx")
        tid = try? map.value("tid")
        tname = try? map.value("tname")
        tag = try? map.value("tag")
        dislike_reasons = try? map.value("dislike_reasons")
        ctime = try? map.value("ctime")
        duration = try? map.value("duration", using: DurationTransform())
        mid = try? map.value("mid")
        name = try? map.value("name")
        face = try? map.value("face")
        area = try? map.value("area")
        area_id = try? map.value("area_id")
        area2 = try? map.value("area2")
        online = try? map.value("online", using: NumberTransform())
        hash = try? map.value("hash")
        rcmd_reason = try? map.value("rcmd_reason")
        banner_item = try? map.value("banner_item")
        badge = try? map.value("badge")
        hide_badge = try? map.value("hide_badge")
        category = try? map.value("category")
        banner_url = try? map.value("banner_url")
        count = try? map.value("count")
        tags = try? map.value("tags")
    }

    init(isShowTip:Bool) {
        self.isShowTip = isShowTip
    }
}

struct TogetherDislikeModel: ImmutableMappable {
    
    var reason_type: TogetherDislikeType
    var reason_name: String
    
    init(map: Map) throws {
        reason_type = try map.value("reason_id", using: EnumTransform<TogetherDislikeType>())
        reason_name = try map.value("reason_name")
    }
    
    init(reason_name: String,reason_type: TogetherDislikeType) {
        self.reason_name = reason_name
        self.reason_type = reason_type
    }
}

struct TogetherTagModel: ImmutableMappable {
    
    var tag_name: String
    var tag_id: Int
    var count: TogetherCountModel?
    
    init(map: Map) throws {
        tag_name = try map.value("tag_name")
        tag_id = try map.value("tag_id")
        count = try? map.value("count")
    }
}

struct TogetherCountModel: ImmutableMappable {
    
    var atten: Int
    
    init(map: Map) throws {
        atten = try map.value("atten")
    }
}

struct TogetherRcmdReasonModel: ImmutableMappable {
    
    var bg_color: Int
    var content: String
    var icon_location: String
    var id: String
    
    init(map: Map) throws {
        bg_color = try map.value("bg_color")
        content = try map.value("content")
        icon_location = try map.value("icon_location")
        id = try map.value("id")
    }
}

struct TogetherArea2Model: ImmutableMappable {
    var id: Int
    var name: String
    var children: TogetherChildrenModel
    
    init(map: Map) throws {
        name = try map.value("name")
        children = try map.value("children")
        id = try map.value("id")
    }
}

struct TogetherChildrenModel: ImmutableMappable {
    var id: Int
    var name: String
    
    init(map: Map) throws {
        name = try map.value("name")
        id = try map.value("id")
    }
}


struct TogetherBannerModel: ImmutableMappable {
    
    var cm_mark: Int?
    var hash: String?
    var server_type: Int?
    var id: Int?
    var resource_id: Int?
    var is_ad: Bool?
    var is_ad_loc: Bool?
    var title: String?
    var image: String?
    var request_id: String?
    var uri: String?
    var index: Int?
    
    init(map: Map) throws {
        cm_mark = try? map.value("cm_mark")
        hash = try? map.value("hash")
        server_type = try? map.value("server_type")
        id = try? map.value("id")
        resource_id = try? map.value("resource_id")
        title = try? map.value("title")
        image = try? map.value("image")
        request_id = try? map.value("request_id")
        uri = try? map.value("uri")
        index = try? map.value("index")
        is_ad = try? map.value("is_ad")
        is_ad_loc = try? map.value("is_ad_loc")
    }
}
