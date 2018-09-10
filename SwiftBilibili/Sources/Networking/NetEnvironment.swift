//
//  NetEnvironment.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/11.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Foundation

import SwiftyUserDefaults

enum NetEnvironment:String,DefaultsSerializable {
    case dev = "测试服"  //测试环境
    case res = "正式服"  //线上
}


enum HttpRequest {
    case app
    case api
    case bangumi
    case live
}

extension HttpRequest {
    
    var path: String {
        
        let environment = Defaults[.currentEnvironment]

        switch self {
        case .app:
            return environment == .res ? "http://app.bilibili.com" : "app"
        case .api:
            return environment == .res ? "http://api.bilibili.com" : "api"
        case .bangumi:
            return environment == .res ? "http://bangumi.bilibili.com" : "bangumi"
        case .live:
            return environment == .res ? "http://api.live.bilibili.com" : "live"
        }
    }
}


