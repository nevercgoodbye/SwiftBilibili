//
//  HomeAPI.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import Moya
import SwiftyUserDefaults

enum HomeAPI {
    //广告页
    case splash
    
    //推荐
    case recommendTogetherList(refreshType:TogetherRefreshType,idx:String,hash:String)
    case recommendBranch  //首页标题
    case watchLater(idx:String)    //稍后观看
    case rankWholeStation
    case rankRegion(regionType:RankRegionType) //排行榜
    case branchData(id: Int)
    
    //直播
    case liveModuleList(moduleId:Int)
    case liveUserSetting
    case liveTotal(subType:LiveAllSubType,page:Int) //全部直播
    
    //番剧
    case dramaPage
    case dramaFall(cursor:String)
    case dramaRcmd //追番推荐
    case dramaFollow(season_id:String,season_type:String) //追番
    case dramaUnFollow(season_id:String,season_type:String) //取消追番
    case dramaLike(page:Int) //我的追番
}

extension HomeAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .recommendTogetherList,.recommendBranch,.rankWholeStation,.rankRegion,.splash,.branchData:
           return URL(string: HttpRequest.app.path)!
        case .watchLater,.dramaPage,.dramaFall:
           return URL(string: HttpRequest.api.path)!
        case .dramaRcmd,.dramaFollow,.dramaUnFollow,.dramaLike:
           return URL(string: HttpRequest.bangumi.path)!
        case .liveModuleList,.liveTotal,.liveUserSetting:
           return URL(string: HttpRequest.live.path)!
        }
    }
    
    var path: String {
        
        switch self {
        case .splash:
            return "/x/v2/splash/list"
        case .recommendTogetherList:
            return "/x/feed/index"
        case .recommendBranch,.branchData:
            return "/x/feed/index/tab"
        case .watchLater:
            return "/x/member/v2/notice"
        case .rankWholeStation:
            return "/x/v2/rank"
        case .rankRegion:
            return "/x/v2/rank/region"
        case .liveModuleList:
            return "/room/v2/AppIndex/getAllList"
        case .liveUserSetting:
            return "live_user/v1/UserSetting/get_tag"
        case .liveTotal:
            return "/mobile/rooms"
        case .dramaPage:
            return "/pgc/app/page/bangumi"
        case .dramaFall:
            return "/pgc/operation/api/fall"
        case .dramaRcmd:
            return "/api/concern_recommend"
        case .dramaFollow:
            return "/follow/api/season/follow"
        case .dramaUnFollow:
            return "/follow/api/season/unfollow"
        case .dramaLike:
            return "/api/get_concerned_season"
        }
    }
    
    var method: Moya.Method {
        switch self {
    case .splash,.recommendTogetherList,.recommendBranch,.branchData,.watchLater,.rankWholeStation,.rankRegion,.liveModuleList,.liveUserSetting,.liveTotal,.dramaPage,.dramaRcmd,.dramaFall,.dramaFollow,.dramaUnFollow,.dramaLike:
            return .get
        }
    }
    
    var task: Task {
        
        switch self {
        case .splash:
            return .requestParameters(parameters: ["access_key":"922ba3eee4e6661a6414e665cd082351","actionKey":"appkey","appkey":"27eb53fc9058f8c3","birth":"0923","build":"6720","device":"phone","height":"2430","mobi_app":"iphone","platform":"ios","sign":"da8f43ed8908f3a31400e1f4652587e2","ts":"1528709529","width":"1125"], encoding: URLEncoding.default)
            
        case let .recommendTogetherList(refreshType,idx,hash):
            var banner_hash: String = ""
            var open_event: String = ""
            var pull: String = ""
            
            let login_event: String = Defaults[.isLogin] ? "2" : "1"
            let qn: String = Defaults[.isLogin] ? "32" : "16"
            
            switch refreshType {
            case .none:
                banner_hash = ""
                open_event = "cold"
                pull = "1"
            case .pullRefresh:
                banner_hash = hash
                open_event = "hot"
                pull = "1"
            case .loadMore:
                banner_hash = hash
                pull = "0"
                open_event = ""
            }
            var parameters = ["actionKey":"appkey","ad_extra":"810E76EA5A485E00B1241CDE55B074B4AF30DDAE19B8F880B3F2E63AE0B988D1675D9758CBDDF4F38FD87B3B16316423B2E7565A4BC0DB7414A1607B7CACCA4C08B25D229F8851C31628A43BA8BB7F322E712851346B9E110EAA6C6F859B726AE21A91134E1D8A1658637A7712A835A5DC4F8005DE2FF7983C5A3E1890C055AEDEEFA3A99EDD1AEF74733C9AD70198CD286B529EBAFB2C9B2345A06B1F97E249B8B08D894183BDAC7B55703192F16F585029D92CB6B612D3C3E101C994B778FA7F465CB22CF30D36CA90ADC413731BF5EB68FFC42AD2F63136323AFBD8588D7C9D48E8E320A2EE79E4CCB771DA0292CA7F5A26E85B910AFA72E7FDA0ED82174F1FE2C92088B86D5996E6E2B06F80D78DAFDDF94C08B2919E90F419DCA90DD91A4D428F4A5B33DA2BD535EF826CC2B181EC1DEBBB849532EF4A85F90395BC8499790910267C1ADAF4E73DFFF5ADD4D5113526B52C787FE4CF15CF00029C9B6DC1C2D9C5AEF9BDB81E448620E0BD67E173297835B9531F9AD0028872CC76ABB60CF898154644C195BB3038370CA80D200FD3830BA9F9917CBA76C116C8052087C20CF5BB16879BEE5C9C915635D5BC79C873A2C2E6ED820EADBE71090A0260D62C84E88BDD3F8D0DE64D7AEA7697928DB2F24A4ECECAB9DAA590EDD49ECA5FD57CFCB526E41624196A6A5EB5D790F27F172213A57FD88B7AB7B33B4D672D95AB99","appkey":"27eb53fc9058f8c3","appver":"6570", "banner_hash":banner_hash,"build":"6570","device":"phone","filtered":"1",  "idx":idx,"mobi_app":"iphone","network":"wifi","open_event":open_event,"platform":"ios","pull":pull,"qn":qn,"sign":"24e5a3bd21d8fa06136ffcff9ce2542c","style":"2", "ts":"1521019673"]
            if refreshType == .none {
                parameters.updateValue(login_event, forKey: "login_event")
            }
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .recommendBranch:
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15bf","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","mobi_app":"iphone","platform":"ios","sign":"901747a5b6a429d230f291202dd4dbc9","ts":"1520592426"], encoding: URLEncoding.default)
        case .branchData(let id):
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15bf","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","mobi_app":"iphone","id":id,"platform":"ios","sign":"901747a5b6a429d230f291202dd4dbc9","ts":"1520592426"], encoding: URLEncoding.default)
        case .watchLater:
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15b","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","mid":"39225696","mobi_app":"iphone","platform":"ios","sign":"62d7090dbd7945a4611a531fee07bc46","ts":"1520589443","uuid":"8FBE4D89F6304A8EBEBE4ACEE3D43B1C"], encoding: URLEncoding.default)
        case .rankWholeStation:
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15b","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","pn":"0","ps":"100","order":"all","sign":"70cac15647144da1096a6e08552a5ae6","ts":"1524897741"], encoding: URLEncoding.default)
        case .rankRegion(let regionType):
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15b","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","pn":"0","ps":"100","rid":"\(regionType.rawValue)","sign":"70cac15647144da1096a6e08552a5ae6","ts":"1524897741"], encoding: URLEncoding.default)
            
        case .liveModuleList(let moduleId):
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6830","device":"phone","mobi_app":"iphone","module_id":moduleId,"scale":"3","platform":"ios","sign":"5f53f11dd197deb2b130a4b410e35e03","ts":"1530240886"], encoding: URLEncoding.default)
        case .liveUserSetting:
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"8110","device":"phone","mobi_app":"iphone","platform":"ios","sign":"e9b93e116e9bae562d5a647f2c7a9375","ts":"1536480547"], encoding: URLEncoding.default)
            
            
        case .liveTotal(let subType,let page):
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","area_id":"0","build":"6790","device":"phone","mobi_app":"iphone","page":"\(page)","platform":"ios","sign":allSign(subType),"sort":subType.title], encoding: URLEncoding.default)
        case .dramaPage:
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"8110","device":"phone","mobi_app":"iphone","platform":"ios","sign":"b0878d4162f46e28ff6f689630aece0a","ts":"1536557810"], encoding: URLEncoding.default)
        case .dramaFall(let cursor):
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","area":"0","build":"8110","cursor":cursor,"device":"phone","mobi_app":"iphone","pageSize":"10","platform":"ios","sign":"27d40c17950ceb5654749458342fdd08","ts":"1536558477","wid":"78%2C79%2C80%2C81%2C59"], encoding: URLEncoding.default)
        case .dramaRcmd:
            return .requestParameters(parameters: ["access_key":"ecec2f83c089316cd8cc1b9864504a90","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","sign":"b98eefa142da409bdd041a6bbe82ef58","ts":"1524110617"], encoding: URLEncoding.default)
        case let .dramaFollow(season_id, season_type):
            return .requestParameters(parameters: ["access_key":"ecec2f83c089316cd8cc1b9864504a90","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","season_id":season_id,"season_type":season_type,  "sign":"3ccf6a4b67d4d49f3a067a4f3290303f","ts":"1524121571"], encoding: URLEncoding.default)
        case let .dramaUnFollow(season_id, season_type):
            return .requestParameters(parameters: ["access_key":"ecec2f83c089316cd8cc1b9864504a90","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","season_id":season_id,"season_type":season_type,  "sign":"5503195fc13b0a4ea22aa0b925db2ac1&","ts":"1524121667"], encoding: URLEncoding.default)
       case .dramaLike(let page):
            return .requestParameters(parameters: ["access_key":"ecec2f83c089316cd8cc1b9864504a90","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","page":"\(page)","pagesize":"30","sign":"635e6f2934f0a02dc8545ef8ee90f64a","taid":"","ts":"1524212252"], encoding: URLEncoding.default)
        }
    }

    var headers: [String: String]? {
        return ["Content-Type": "application/json","Authorization":"e33df9f018ff40ecb025a2b9fee071f6"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
    private func allSign(_ subType: LiveAllSubType) -> String {
        switch subType {
        case .hottest:
            return "601836cd52051dbcba792220dc7c3785"
        case .latest:
            return "7644428211e24cd2cce4200c95379d84"
        case .roundroom:
            return "dd16d5c3da2516cefa9b5e4ad4c12248&"
        }
    }
    
}
