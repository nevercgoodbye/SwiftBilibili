//
//  TogetherRealmModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/23.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RealmSwift

final class TogetherRealmModel: Object {

    @objc dynamic var data: Data? = nil
    @objc dynamic var key: String = ""
    
    //设置数据库主键
    override static func primaryKey() -> String? {
        return "key"
    }
}
