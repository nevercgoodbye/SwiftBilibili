//
//  SplashModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/11.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper

struct SplashModel:ImmutableMappable {
    
    var max_time: Int
    var min_interval: Int
    var pull_interval: Int
    var list:[ListModel]
    var show:[ShowModel]?
    
    init(map: Map) throws {
        max_time = try map.value("max_time")
        min_interval = try map.value("min_interval")
        pull_interval = try map.value("pull_interval")
        list = try map.value("list")
        show = try? map.value("show")
    }
    
}

struct ListModel:ImmutableMappable {
    
    var id: Int
    var type: Int
    var card_type: Int
    var duration: Int
    var begin_time: Int
    var end_time: Int
    var thumb: String
    var hash: String
    var logo_url: String
    var logo_hash: String
    var skip: Int
    var uri: String
    var uri_title: String
    var source: Int
    var ad_cb: String
    var resource_id: Int
    var request_id: String
    var client_ip: String
    var is_ad: Bool
    var is_ad_loc: Bool
    var extra:ExtraModel
    
    init(map: Map) throws {
        id = try map.value("id")
        type = try map.value("type")
        card_type = try map.value("card_type")
        duration = try map.value("duration")
        begin_time = try map.value("begin_time")
        end_time = try map.value("end_time")
        thumb = try map.value("thumb")
        hash = try map.value("hash")
        logo_url = try map.value("logo_url")
        logo_hash = try map.value("logo_hash")
        skip = try map.value("skip")
        uri = try map.value("uri")
        uri_title = try map.value("uri_title")
        source = try map.value("source")
        ad_cb = try map.value("ad_cb")
        resource_id = try map.value("resource_id")
        request_id = try map.value("request_id")
        client_ip = try map.value("client_ip")
        is_ad = try map.value("is_ad")
        is_ad_loc = try map.value("is_ad_loc")
        extra = try map.value("extra")
    }
    
}

struct ExtraModel:ImmutableMappable {
    
    var use_ad_web_v2: Bool
    //show_urls: []
    //click_urls: [""]
    //download_whitelist: []
    init(map: Map) throws {
        use_ad_web_v2 = try map.value("use_ad_web_v2")
    }
}

struct ShowModel:ImmutableMappable {
    var id: Int
    var stime: Int
    var etime: Int
    
    init(map: Map) throws {
        id = try map.value("id")
        stime = try map.value("stime")
        etime = try map.value("etime")
    }
}
