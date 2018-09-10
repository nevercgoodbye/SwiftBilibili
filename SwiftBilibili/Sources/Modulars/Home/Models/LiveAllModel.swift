//
//  LiveAllModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/3.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit
import ObjectMapper

struct LiveAllModel: ImmutableMappable {
    
    var owner: LiveOwnerModel
    var cover: LiveCoverModel
    var room_id: Int?
    var title: String
    var online: String
    var play_url: String?
    var area_id: Int?
    var accept_quality: String
    var broadcast_type: Int
    var area: String?
    var live_time: String?
    var on_flag: Int
    var round_status: Int
    var area_v2_id: Int?
    var area_v2_name: String?
    var area_v2_parent_id: Int?
    var area_v2_parent_name: String?
    
    init(map: Map) throws {
        owner = try map.value("owner")
        cover = try map.value("cover")
        room_id = try? map.value("room_id")
        title = try map.value("title")
        online = try map.value("online", using: NumberTransform())
        area_id = try? map.value("area_id")
        play_url = try? map.value("play_url")
        accept_quality = try map.value("accept_quality")
        broadcast_type = try map.value("broadcast_type")
        area = try? map.value("area")
        live_time = try? map.value("live_time")
        on_flag = try map.value("on_flag")
        round_status = try map.value("round_status")
        area_v2_id = try? map.value("area_v2_id")
        area_v2_name = try? map.value("area_v2_name")
        area_v2_parent_id = try? map.value("area_v2_parent_id")
        area_v2_parent_name = try? map.value("area_v2_parent_name")
    }
}

struct LiveOwnerModel: ImmutableMappable {
    
    var face: String
    var mid: Int
    var name: String
    
    init(map: Map) throws {
        face = try map.value("face")
        mid = try map.value("mid")
        name = try map.value("name")
    }
}

struct LiveCoverModel: ImmutableMappable {
    
    var src: String?
    var height: Int
    var width: Int
    
    init(map: Map) throws {
        src = try? map.value("src")
        height = try map.value("height")
        width = try map.value("width")
    }
}

