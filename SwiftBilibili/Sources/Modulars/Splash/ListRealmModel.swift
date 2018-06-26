//
//  ListRealmModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/11.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RealmSwift

class ListRealmModel: Object {

    @objc dynamic var key: String = "ListRealmModel"
    @objc dynamic var id: Int = 0
    @objc dynamic var type: Int = 0
    @objc dynamic var card_type: Int = 0
    @objc dynamic var duration: Int = 0
    @objc dynamic var begin_time: Int = 0
    @objc dynamic var end_time: Int = 0
    @objc dynamic var thumb: String = ""
    @objc dynamic var logo_url: String = ""
    @objc dynamic var logo_hash: String = ""
    @objc dynamic var skip: Int = 0
    @objc dynamic var uri: String = ""
    @objc dynamic var uri_title: String = ""
    @objc dynamic var source: Int = 0
    @objc dynamic var ad_cb: String = ""
    @objc dynamic var resource_id: Int = 0
    @objc dynamic var request_id: String = ""
    @objc dynamic var client_ip: String = ""
    @objc dynamic var is_ad: Bool = false
    @objc dynamic var is_ad_loc: Bool = false

    //设置数据库主键
    override static func primaryKey() -> String? {
        return "key"
    }

    func storge(list:ListModel) {

        self.id = list.id
        self.type = list.type
        self.card_type = list.card_type
        self.duration = list.duration
        self.begin_time = list.begin_time
        self.end_time = list.end_time
        self.thumb = list.thumb
        self.logo_url = list.logo_url
        self.logo_hash = list.logo_hash
        self.skip = list.skip
        self.uri = list.uri
        self.uri_title = list.uri_title
        self.source = list.source
        self.ad_cb = list.ad_cb
        self.resource_id = list.resource_id
        self.request_id = list.request_id
        self.client_ip = list.client_ip
        self.is_ad = list.is_ad
        self.is_ad_loc = list.is_ad_loc
    }

}
