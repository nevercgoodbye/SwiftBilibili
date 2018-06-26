//
//  RankModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ObjectMapper


struct RankModel: ModelType {
    
    enum Event {}
    
    var title: String
    var cover: String
    var uri: String
    var param: String
    var goto: TogetherDataType
    var mid: Int
    var name: String
    var face: String
    var follower: Int
    var play: Int
    var danmaku: Int
    var reply: Int
    var favourite: Int
    var children: [RankChildrenModel]
    
    init(map: Map) throws {
        title = try map.value("title")
        cover = try map.value("cover")
        uri = try map.value("uri")
        param = try map.value("param")
        goto = try map.value("goto")
        mid = try map.value("mid")
        name = try map.value("name")
        face = try map.value("face")
        play = try map.value("play")
        danmaku = try map.value("danmaku")
        reply = try map.value("reply")
        favourite = try map.value("favourite")
        children = try map.value("children")
        follower = try map.value("follower")
    }
}

struct RankChildrenModel:ImmutableMappable {
    
    var title: String
    var cover: String
    var uri: String
    var param: String
    var goto: TogetherDataType
    var mid: Int
    var name: String
    var face: String
    var play: Int
    var danmaku: Int
    var reply: Int
    var favourite: Int
    var pts: Int
    var pubdate: Int
    var duration: Int
    var rid: Int
    var rname: String
    var like: Int
    
    init(map: Map) throws {
        title = try map.value("title")
        cover = try map.value("cover")
        uri = try map.value("uri")
        param = try map.value("param")
        goto = try map.value("goto")
        mid = try map.value("mid")
        name = try map.value("name")
        face = try map.value("face")
        play = try map.value("play")
        danmaku = try map.value("danmaku")
        reply = try map.value("reply")
        favourite = try map.value("favourite")
        pts = try map.value("pts")
        pubdate = try map.value("pubdate")
        duration = try map.value("duration")
        rid = try map.value("rid")
        rname = try map.value("rname")
        like = try map.value("like")
    }
}
