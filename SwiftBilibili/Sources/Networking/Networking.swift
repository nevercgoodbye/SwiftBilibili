//
//  Networking.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Moya
import RxSwift

typealias HomeNetworking = Networking<HomeAPI>

final class Networking<Target: TargetType>: MoyaProvider<Target> {
    
    init(plugins: [PluginType] = [LoadingPlugin()]) {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = Manager.defaultHTTPHeaders
        configuration.timeoutIntervalForRequest = kTimeoutIntervalForRequest
        
        let manager = Manager(configuration: configuration)
        manager.startRequestsImmediately = false
        
        super.init(endpointClosure:Networking.endpointMapping ,manager: manager, plugins: plugins)
     }
    
    func request(
        _ target: Target,
        _ isCache: Bool = false,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
        ) -> Single<Response> {
        let requestString = "\(target.method) \(target.path)"
        
        return self.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(onSuccess: { (value) in
                let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                log.debug(message, file: file, function: function, line: line)
                
            }, onError: {(error) in
            
                NotificationCenter.post(customNotification: .netError)
                
                if let response = (error as? MoyaError)?.response {
                if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                log.warning(message, file: file, function: function, line: line)
                } else if let rawString = String(data: response.data, encoding: .utf8) {
                let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                log.warning(message, file: file, function: function, line: line)
                } else {
                let message = "FAILURE: \(requestString) (\(response.statusCode))"
                log.warning(message, file: file, function: function, line: line)
                }
                } else {
                let message = "FAILURE: \(requestString)\n\(error)"
                log.warning(message, file: file, function: function, line: line)
                }
            }, onSubscribed: {
                let message = "REQUEST: \(requestString)"
                log.debug(message, file: file, function: function, line: line)
            })
    }
    
    private static func endpointMapping<Target: TargetType>(target: Target) -> Endpoint {
    
        var param: [String:Any] = [:]
        switch target.task {
        case let .requestParameters(parameters, _):
            param = parameters
        default:break
        }
    
        var url = "\(target.baseURL)\(target.path)?"
        
        if target.method == .get {
            
            
            let s = param.map { (key,value) -> String in
                
                return "\(key)=\(value)&"
            }
            
            for p in s {
                url += p
            }
            
            url.remove(at: String.Index(encodedOffset: url.count - 1))
            
            log.info("请求链接:\(url) \n 请求方法:\(target.method)")
            
        }else{
            log.info("请求链接:\(url) \n 参数:\(param) \n 请求方法:\(target.method)")
            
        }
    
        return MoyaProvider.defaultEndpointMapping(for: target)
    }
    
}
