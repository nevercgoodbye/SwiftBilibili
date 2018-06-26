//
//  DurationTransform.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper

final class DurationTransform: TransformType {

    typealias Object = String
    typealias JSON = Int
    
    init() {}
    
    //都没有支持模型转JSON,暂时用不上就没处理，直接返回的nil
    func transformToJSON(_ value: String?) -> Int? {
        return nil
    }
    
    func transformFromJSON(_ value: Any?) -> String? {
        
        guard let duration = value as? Int else { return nil }
        
        let seconds = duration % 60;
        let minutes = (duration / 60) % 60;
        let hours = duration / 3600
        
        if hours > 0 {
            return String(format: "%02d:%02d:%02d",hours,minutes,seconds )
        }else{
            return String(format: "%02d:%02d",minutes,seconds)
        }
        
        
    }
    
}
