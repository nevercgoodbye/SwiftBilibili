//
//  LoadingPlugin.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Moya
import Result

struct LoadingPlugin : PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
    
        
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
            
       
        
    }

}
