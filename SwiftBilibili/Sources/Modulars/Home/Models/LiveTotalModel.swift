//
//  LiveTotalModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/24.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper
import RxSwift

struct LiveTotalModel: ImmutableMappable {

    enum Event {
       case exchange(moduleId:Int)
    }
    
    static let event = PublishSubject<Event>()
    
    var interval: Int
    var module_list: [LiveModuleListModel]
    
    init(map: Map) throws {
        interval = try map.value("interval")
        module_list = try map.value("module_list")
    }
}

struct LiveModuleListModel: ImmutableMappable {
    
    var module_info: LiveHeaderModel
    var list: [LiveAvModel]
    
    init(map: Map) throws {
        module_info = try map.value("module_info")
        list = try map.value("list")
    }
}

struct LiveHeaderModel: ImmutableMappable {
    
    var id: Int
    var type: Int
    var pic: String
    var link: String
    var title: String
    var count: Int?
    var sub_title: String?
    
    init(map: Map) throws {
        id = try map.value("id")
        pic = try map.value("pic")
        type = try map.value("type")
        link = try map.value("link")
        title = try map.value("title")
        count = try? map.value("count")
        sub_title = try? map.value("sub_title")
    }
}

struct LiveUserSettingModel: ImmutableMappable {
    
    var tags: [LiveTagModel] = []

    
    init(map: Map) throws {
        tags = try map.value("tags")
    }
}

struct LiveTagModel: ImmutableMappable {
    
    var id: Int
    var name: String?
    var parent_id: Int?
    var parent_name: String?
    var act_id: Int?
    var pic: String?
    var is_advice: Int?
    
    init(map: Map) throws {
        id = try map.value("id")
        pic = try? map.value("pic")
        name = try? map.value("name")
        parent_id = try? map.value("parent_id")
        parent_name = try? map.value("parent_name")
        act_id = try? map.value("act_id")
        is_advice = try? map.value("is_advice")
    }
}




struct LiveAvModel: ImmutableMappable,Hashable {
    
    var hashValue: Int {
        return Int(self.id ?? "0") ?? 0
    }
    
    var id: String?
    var pic: String?
    var roomid: Int?
    var title: String?
    var uname: String?
    var online: String?
    var cover: String?
    var link: String?
    var face: String?
    var area_v2_parent_id: Int?
    var area_v2_id: Int?
    var area_v2_parent_name: String?
    var area_v2_name: String?
    var play_url: String?
    var broadcast_type: Int?
    var pendent_ru: String?
    var pendent_ru_color: String?
    
    var isLeft: Bool = true
    
    init(map: Map) throws {
        id = try? map.value("id")
        pic = try? map.value("pic")
        roomid = try? map.value("roomid")
        cover = try? map.value("cover")
        title = try? map.value("title")
        uname = try? map.value("uname")
        online = try? map.value("online", using: NumberTransform())
        link = try? map.value("link")
        face = try? map.value("face")
        play_url = try? map.value("play_url")
        broadcast_type = try? map.value("broadcast_type")
        area_v2_parent_name = try? map.value("area_v2_parent_name")
        area_v2_name = try? map.value("area_v2_name")
        area_v2_parent_id = try? map.value("area_v2_parent_id")
        area_v2_id = try? map.value("area_v2_id")
        pendent_ru = try? map.value("pendent_ru")
        pendent_ru_color = try? map.value("pendent_ru_color")
    }
    
    init(allModel:LiveAllModel) {
        self.title = allModel.title
        self.uname = allModel.owner.name
        self.online = allModel.online
        self.play_url = allModel.play_url
        self.cover = allModel.cover.src
        self.roomid = allModel.room_id
    }
    
}
