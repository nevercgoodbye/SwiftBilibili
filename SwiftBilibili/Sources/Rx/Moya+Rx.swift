//
//  Moya+Rx.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Moya
import RxSwift
import SwiftyJSON
import ObjectMapper

extension PrimitiveSequence where TraitType == SingleTrait, Element == Moya.Response {

    func map<T: ImmutableMappable>(_ type: T.Type) -> PrimitiveSequence<TraitType, T> {
       return self
           .map { (response) -> T in
             let json = try JSON(data: response.data)
             guard let code = json[RESULT_CODE].int else { throw RequestError.noCodeKey }
             if code != StatusCode.success.rawValue { throw RequestError.sysError(statusCode:"\(code)" , errorMsg: json[RESULT_MESSAGE].string) }
            if let data = json[RESULT_DATA].dictionaryObject {
                return try Mapper<T>().map(JSON: data)
            }else if let data = json[RESULT_RESULT].dictionaryObject {
                return try Mapper<T>().map(JSON: data)
            }
        
             throw RequestError.noDataKey
        }.do(onSuccess: { (_) in
            
        }, onError: { (error) in
            if error is MapError {
                log.error(error)
            }
        })
    }
    
    func map<T: ImmutableMappable>(_ type: T.Type) -> PrimitiveSequence<TraitType, [T]> {
        return self
            .map { response -> [T] in
                 let json = try JSON(data: response.data)
                 guard let code = json[RESULT_CODE].int else { throw RequestError.noCodeKey }
                 if code != StatusCode.success.rawValue { throw RequestError.sysError(statusCode:"\(code)" , errorMsg: json[RESULT_MESSAGE].string) }
                 var jsonArray: [Any] = []
                 if let array = json[RESULT_DATA].arrayObject {
                    jsonArray = array
                 }else if let array = json[RESULT_RESULT].arrayObject {
                    jsonArray = array
                 }else{
                    throw RequestError.noDataKey
                 }
                 guard let data = try? JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted),
                       let jsonString = String(data: data, encoding: String.Encoding.utf8)
                 else { throw RequestError.wrongData }
                
                 return try Mapper<T>().mapArray(JSONString: jsonString)
                
            }.do(onSuccess: { (_) in
                
            }, onError: { (error) in
                if error is MapError {
                    log.error(error)
                }
            })
    }
}
