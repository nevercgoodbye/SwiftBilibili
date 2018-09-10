//
//  DefaultsKeys+Key.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/16.
//  Copyright © 2018年 罗文. All rights reserved.
//

import SwiftyUserDefaults

extension DefaultsKeys {
    
    static let openTimes = DefaultsKey<Int>("openTimes", defaultValue: 0)

    static let avIdx = DefaultsKey<String>("avIdx",defaultValue:"0")
    
    static let isLogin = DefaultsKey<Bool>("isLogin",defaultValue:false)
    
    static let avater = DefaultsKey<Data>("avater", defaultValue: Data())
    
    static let currentEnvironment = DefaultsKey<NetEnvironment>("currentEnvironment", defaultValue: .res)
}
