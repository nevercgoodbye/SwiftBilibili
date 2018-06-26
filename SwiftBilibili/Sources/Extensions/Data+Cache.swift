//
//  Data+Cache.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/22.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper
import SwiftyJSON

extension Data {
    
    func cacheObject<T: ImmutableMappable>(_ type: T.Type) -> T {
        
        let json = try! JSON(data: self)
        let data = json[RESULT_DATA].dictionaryObject
        return try! Mapper<T>().map(JSON: data!)
    }
    
    func cacheArray<T: ImmutableMappable>(_ type: T.Type) -> [T] {
    
        let jsonArray = try! JSON(data: self).arrayObject
        let data = try! JSONSerialization.data(withJSONObject: jsonArray!, options: JSONSerialization.WritingOptions.prettyPrinted)
        let jsonString = String(data: data, encoding: String.Encoding.utf8)!
        
        return try! Mapper<T>().mapArray(JSONString: jsonString)
    }
}
