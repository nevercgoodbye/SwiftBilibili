//
//  BranchDataModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/5.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ObjectMapper

struct BranchDataModel: ImmutableMappable {
    
    var cover: String
    var item: [BranchItemModel]
    
    init(map: Map) throws {
        cover = try map.value("cover")
        item = try map.value("item")
    }
}

struct BranchItemModel:ImmutableMappable {
   
    var param: String?
    var goto: TogetherDataType
    var duration: Int?
    var title: String?
    var cover: String?
    var redirect: String?
    var uri: String?
    var desc: String?
    var play: Int?
    var reply: String?
    var ctime: Int?
    var mid: Int?
    var name: String?
    var face: String?
    var banner_url: String?
    var badge: String?
    var item: [BranchAvModel]?
    var banner_item:[TogetherBannerModel]?
    
    init(map: Map) throws {
        param = try? map.value("param")
        title = try? map.value("title")
        redirect = try? map.value("redirect")
        cover = try? map.value("cover")
        uri = try? map.value("uri")
        duration = try? map.value("duration")
        goto = try map.value("goto", using: EnumTransform<TogetherDataType>())
        desc = try? map.value("desc")
        play = try? map.value("play")
        reply = try? map.value("reply", using: NumberTransform())
        ctime = try? map.value("ctime")
        mid = try? map.value("mid")
        name = try? map.value("name")
        face = try? map.value("face")
        banner_url = try? map.value("banner_url")
        badge = try? map.value("badge")
        item = try? map.value("item")
        banner_item = try? map.value("banner_item")
    }
}

struct BranchAvModel: ImmutableMappable {

    var title: String?
    var cover: String?
    var goto: TogetherDataType
    var uri: String?
    var param: String?
    var desc: String?
    var play: String?
    var danmaku: String?
    var duration: String?
    var tname: String?
    
    init(map: Map) throws {
        title = try? map.value("title")
        cover = try? map.value("cover")
        uri = try? map.value("uri")
        param = try? map.value("param")
        goto = try map.value("goto")
        desc = try? map.value("desc")
        play = try? map.value("play", using: NumberTransform())
        danmaku = try? map.value("danmaku", using: NumberTransform())
        duration = try? map.value("duration", using: DurationTransform())
        tname = try? map.value("tname")
    }
}

