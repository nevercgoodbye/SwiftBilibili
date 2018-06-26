//
//  ModelType.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Then
import ObjectMapper

protocol ModelType: ImmutableMappable,Then {
    associatedtype Event
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy { get }
}

extension ModelType {
    static var dateDecodingStrategy: JSONDecoder.DateDecodingStrategy {
        if #available(iOS 10.0, *) {
            return .iso8601
        } else {
            return .secondsSince1970
        }
    }
    
    static var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = self.dateDecodingStrategy
        return decoder
    }
}
