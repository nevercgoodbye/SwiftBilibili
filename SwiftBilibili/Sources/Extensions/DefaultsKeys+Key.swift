//
//  DefaultsKeys+Key.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/16.
//  Copyright © 2018年 罗文. All rights reserved.
//

import SwiftyUserDefaults

typealias CategoryNames = [Int]
typealias Idx = String
typealias Environment = NetEnvironment

extension DefaultsKeys {
    
    static let openTimes = DefaultsKey<Int>("openTimes")
    
    static let liveCategoryNames = DefaultsKey<CategoryNames>("liveCategoryNames")

    static let avIdx = DefaultsKey<Idx>("avIdx")
    
    static let isLogin = DefaultsKey<Bool>("isLogin")
    
    static let avater = DefaultsKey<Data>("avater")
    
    static let currentEnvironment = DefaultsKey<Environment>("currentEnvironment")
}

extension UserDefaults {
    subscript(key: DefaultsKey<CategoryNames>) -> CategoryNames {
        get { return unarchive(key) ?? [666,1,2,3,4]}
        set { archive(key, newValue) }
    }
    
    subscript(key: DefaultsKey<Idx>) -> Idx {
        get { return unarchive(key) ?? "0"}
        set { archive(key, newValue) }
    }
    
    subscript(key: DefaultsKey<Environment>) -> Environment {
        get { return unarchive(key) ?? .res}
        set { archive(key, newValue) }
    }
}
