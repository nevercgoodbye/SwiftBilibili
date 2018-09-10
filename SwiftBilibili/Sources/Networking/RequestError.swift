//
//  RequestError.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/16.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxSwift

///定义返回的JSON数据字段
let RESULT_CODE = "code"//状态码
let RESULT_MESSAGE = "message"//错误消息提示
let RESULT_DATA = "data"//数据包
let RESULT_RESULT = "result"//数据包

enum RequestError: Swift.Error {
    case noCodeKey
    case noDataKey
    case wrongData
    case sysError(statusCode: String?, errorMsg: String?)
}

extension RequestError {
    
    var errorDescription: String {
        
        switch self {
        case .noCodeKey,.noDataKey,.wrongData:
            return "解析数据错误"
        case .sysError(_, let errorMsg):
            return errorMsg ?? "无错误信息"
        }
    }
}


enum StatusCode: Int {
    case success = 0
    case unknow
}

extension Single {
    
    func handleError(_ element: Element? = nil,
                     showText:String = "似乎与互联网断开连接",
                     bottomOffset:CGFloat = kToastBottomCenterSpace
        ) -> Single<Element> {
        
        if let element = element {
            
            return self.asObservable().catchErrorJustReturn(element).asSingle()
           
        }else {
            return self.asObservable().do(onError: { (error) in
                if error is RequestError {
                    BilibiliToaster.show((error as! RequestError).errorDescription)
                }else{
                    BilibiliToaster.show(showText,bottomOffsetPortrait:bottomOffset)
                }
            }).asSingle()
            
        }
    }
}





