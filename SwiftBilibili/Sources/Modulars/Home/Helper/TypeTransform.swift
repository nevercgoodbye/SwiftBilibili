//
//  TypeTransform.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper

final class TypeTransform: TransformType {
    
    typealias Object = String
    typealias JSON = Int
    
    init() {}
    
    //都没有支持模型转JSON,暂时用不上就没处理，直接返回的nil
    func transformToJSON(_ value: String?) -> Int? {
        return nil
    }
    
    func transformFromJSON(_ value: Any?) -> String? {
        
        if let type = value as? Int {
            return "\(type)"
        }else if let type = value as? String {
            return type
        }
        
        return nil
    }
    
}
