//
//  LoadingPlugin.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Moya
import Result

class LoadingPlugin : PluginType {
    
    func willSend(_ request: RequestType, target: TargetType) {
//        if target is HomeAPI {
//            let api = target as! HomeAPI
//            if api.isShowLoading {
//                guard let curController = UIViewController.topMost else { return }
//                curController.showLoadingAnimation(superView: curController.view)
//            }
//        }
    }
    
    func didReceive(_ result: Result<Response, MoyaError>, target: TargetType) {
//        if target is HomeAPI {
//            let api = target as! HomeAPI
//            if api.isShowLoading {
//                guard let curController = UIViewController.topMost else { return }
//                curController.hideLoadingAnimation(superView: curController.view)
//            }
//        }
    }

}
