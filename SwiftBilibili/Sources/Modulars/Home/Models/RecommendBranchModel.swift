//
//  RecommendBranchModel.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper

struct RecommendBranchModel: ImmutableMappable {

    var tab: [BranchTabModel] = []
    
    init(map: Map) throws {
        tab = try map.value("tab")
    }
}

struct BranchTabModel: ImmutableMappable {
    
    var id: Int
    var name: String
    
    init(map: Map) throws {
        id = try map.value("id")
        name = try map.value("name")
    }
    
}

