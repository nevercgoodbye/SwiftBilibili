//
//  LiveTotalModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/24.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper

struct LiveTotalModel: ModelType {

    enum Event {
       case refreshRecommendPartition
       case refreshCommonPartition(LivePartitionType)
    }
    
    var banner : [LiveListBannerModel]
    var entranceIcons : [LiveEntranceIconModel]
    var partitions : [LivePartitionModel]
    var star_show: LivePartitionModel
    var recommend_data: LiveRecommendModel
    
    init(map: Map) throws {
        banner = try map.value("banner")
        entranceIcons = try map.value("entranceIcons")
        partitions = try map.value("partitions")
        star_show = try map.value("star_show")
        recommend_data = try map.value("recommend_data")
    }
}


struct LiveListBannerModel: ImmutableMappable {
    
    var title: String
    var img: String
    var remark: String
    var link: String
    
    init(map: Map) throws {
        title = try map.value("title")
        img = try map.value("img")
        remark = try map.value("remark")
        link = try map.value("link")
    }
    
}

struct LiveEntranceIconModel: ImmutableMappable {
    
    var id: Int
    var name: String
    var entrance_icon: LiveHeaderIconModel
    
    init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
        entrance_icon = try map.value("entrance_icon")
    }
}

struct LiveStarShowModel: ImmutableMappable {
    
    var uid : Int
    var uname : String
    var face: String
    var focus_num: String
    var room_id: Int
    
    init(map: Map) throws {
        uid = try map.value("uid")
        uname = try map.value("uname")
        face = try map.value("face")
        focus_num = try map.value("focus_num", using: NumberTransform())
        room_id = try map.value("room_id")
    }
    
}

struct LivePartitionModel: ImmutableMappable {
    
    var partition : LivePartitionHeaderModel
    var lives : [LivePartitionAvModel]
    
    init(map: Map) throws {
        partition = try map.value("partition")
        lives = try map.value("lives")
    }
    
    init(recommendModel: LiveRecommendModel) {
        partition = recommendModel.partition
        lives = recommendModel.lives.map{LivePartitionAvModel(recommendAvModel: $0)}
    }
}

struct LiveRecommendModel: ImmutableMappable {
    
    var partition : LivePartitionHeaderModel
    var lives : [LiveRecommendAvModel]
    var banner_data : [LiveRecommendBannerModel]
    
    init(map: Map) throws {
        partition = try map.value("partition")
        lives = try map.value("lives")
        banner_data = try map.value("banner_data")
    }
    
}

struct LivePartitionHeaderModel: ImmutableMappable{
    
    var partitionType: LivePartitionType
    var name: String
    var sub_icon : LiveHeaderIconModel
    var count: Int
    var area: String?
    var hidden: Int?
    
    init(map: Map) throws {
        partitionType = try map.value("id", using: EnumTransform<LivePartitionType>())
        name = try map.value("name")
        sub_icon = try map.value("sub_icon")
        count = try map.value("count")
        area = try? map.value("area")
        hidden = try? map.value("hidden")
    }
    
}

struct LivePartitionAvModel: ImmutableMappable{
    
    var roomid: Int
    var uid: Int = 0
    var title: String
    var uname: String = ""
    var online: String = ""
    var user_cover: String = ""
    var system_cover: String = ""
    var user_cover_flag: Int = 0
    var show_cover: String?
    var link: String = ""
    var face: String
    var parent_id: Int = 0
    var parent_name: String = ""
    var area_id: Int = 0
    var area_name: String = ""
    var current_quality: Int = 0
    var play_url: String = ""
    var accept_quality: String = ""
    var is_tv: Int = 0
    var broadcast_type: Int = 0
    
    init(map: Map) throws {
        roomid = try map.value("roomid")
        uid = try map.value("uid")
        title = try map.value("title")
        uname = try map.value("uname")
        online = try map.value("online", using: NumberTransform())
        user_cover = try map.value("user_cover")
        show_cover = try? map.value("show_cover")
        system_cover = try map.value("system_cover")
        user_cover_flag = try map.value("user_cover_flag")
        link = try map.value("link")
        face = try map.value("face")
        parent_id = try map.value("parent_id")
        parent_name = try map.value("parent_name")
        area_id = try map.value("area_id")
        area_name = try map.value("area_name")
        current_quality = try map.value("current_quality")
        play_url = try map.value("play_url")
        accept_quality = try map.value("accept_quality")
        is_tv = try map.value("is_tv")
        broadcast_type = try map.value("broadcast_type")
    }
    
    init(recommendAvModel:LiveRecommendAvModel) {
       roomid = recommendAvModel.room_id
       uid = recommendAvModel.owner.mid
       title = recommendAvModel.title
       uname = recommendAvModel.owner.name
       online = recommendAvModel.online
       user_cover = recommendAvModel.owner.face
       face = recommendAvModel.cover.src ?? ""
       play_url = recommendAvModel.playurl ?? ""
       area_id = recommendAvModel.area_v2_id ?? 0
       area_name = recommendAvModel.area_v2_name ?? ""
       current_quality = recommendAvModel.current_quality ?? 0
       accept_quality = recommendAvModel.accept_quality
       is_tv = recommendAvModel.is_tv ?? 0
    }
}

struct LiveRecommendBannerModel: ImmutableMappable {
    
    var cover: LiveCoverIconModel
    var title: String
    var is_clip: Int
    var new_cover: LiveCoverIconModel
    var new_title: String
    var new_router: String
    
    init(map: Map) throws {
        cover = try map.value("cover")
        title = try map.value("title")
        is_clip = try map.value("is_clip")
        new_cover = try map.value("new_cover")
        new_title = try map.value("new_title")
        new_router = try map.value("new_router")
    }
}

struct LiveRecommendAvModel: ImmutableMappable {
    
    var owner : LiveAnchorModel
    var cover : LiveCoverIconModel
    var room_id: Int
    var check_version: Int?
    var online: String
    var area: String?
    var area_id: Int?
    var title: String
    var playurl: String?
    var current_quality: Int?
    var accept_quality: String
    var broadcast_type: Int
    var is_tv: Int?
    var corner: String?
    var pendent: String?
    var area_v2_id: Int?
    var area_v2_name: String?
    var area_v2_parent_id: Int?
    var area_v2_parent_name: String?

    init(map: Map) throws {
        room_id = try map.value("room_id")
        title = try map.value("title")
        online = try map.value("online", using: NumberTransform())
        area_id = try? map.value("area_id")
        playurl = try? map.value("playurl")
        accept_quality = try map.value("accept_quality")
        current_quality = try? map.value("current_quality")
        broadcast_type = try map.value("broadcast_type")
        is_tv = try? map.value("is_tv")
        corner = try? map.value("corner")
        owner = try map.value("owner")
        cover = try map.value("cover")
        check_version = try? map.value("check_version")
        area = try? map.value("area")
        area_v2_id = try? map.value("area_v2_id")
        area_v2_name = try? map.value("area_v2_name")
        area_v2_parent_id = try? map.value("area_v2_parent_id")
        area_v2_parent_name = try? map.value("area_v2_parent_name")
        pendent = try? map.value("pendent")
    }
}

struct LiveAnchorModel: ImmutableMappable {
    
    var face: String
    var mid: Int
    var name: String
    
    init(map: Map) throws {
        face = try map.value("face")
        name = try map.value("name")
        mid = try map.value("mid")
    }
}

struct LiveCoverIconModel: ImmutableMappable {
    
    var src: String?
    var height: Int
    var width: Int
    
    init(map: Map) throws {
        src = try? map.value("src")
        height = try map.value("height")
        width = try map.value("width")
    }
}


struct LiveHeaderIconModel: ImmutableMappable {
    
    var src: String
    var height: String
    var width: String
    
    init(map: Map) throws {
        src = try map.value("src")
        height = try map.value("height")
        width = try map.value("width")
    }
}
