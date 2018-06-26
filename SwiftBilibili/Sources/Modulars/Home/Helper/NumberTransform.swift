//
//  NumberTransform.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ObjectMapper

final class NumberTransform: TransformType {
    
    typealias Object = String
    typealias JSON = Int
    
    init() {}
    
    //都没有支持模型转JSON,暂时用不上就没处理，直接返回的nil
    func transformToJSON(_ value: String?) -> Int? {
        return nil
    }
    
    func transformFromJSON(_ value: Any?) -> String? {
        
        if let number = value as? Int {
            return numberToString(number)
        }else if let numberString = value as? String,let number = Int(numberString) {
            return numberToString(number)
        }
        
         return nil
    }
    
    private func numberToString(_ number: Int) -> String {
        if number >= 10000  {
            return String(format:"%.1lf万",number.f/10000)
        }else{
            return "\(number)"
        }
    }
    
}
