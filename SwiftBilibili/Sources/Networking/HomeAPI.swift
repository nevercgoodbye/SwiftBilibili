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
    case recommendBranch
    case watchLater(idx:String)
    case rankWholeStation
    case rankRegion(regionType:RankRegionType)
    
    //直播
    case livePartitionList
    case liveRecommendList
    case reloadRecommendPartition
    case reloadCommonPartition(LivePartitionType)
    case getOtherSourceRoomList(page:Int,pageSize:Int)//颜值领域
    case allLive(subType:LiveAllSubType) //共有直播
    
    //番剧
    case dramaPage  //国产+番剧
    case dramaFall(cursor:String)  //编辑推荐
    case dramaMine  //个人记录
    case dramaRcmd //追番推荐
    case dramaFollow(season_id:String,season_type:String) //追番
    case dramaUnFollow(season_id:String,season_type:String) //取消追番
    case dramaLike(page:Int) //我的追番
}

extension HomeAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .recommendTogetherList,.recommendBranch,.rankWholeStation,.rankRegion,.splash:
           return URL(string: HttpRequest.app.path)!
        case .watchLater:
           return URL(string: HttpRequest.api.path)!
        case .dramaPage,.dramaFall,.dramaMine,.dramaRcmd,.dramaFollow,.dramaUnFollow,.dramaLike:
           return URL(string: HttpRequest.bangumi.path)!
    case .livePartitionList,.liveRecommendList,.reloadRecommendPartition,.reloadCommonPartition,.getOtherSourceRoomList,.allLive:
           return URL(string: HttpRequest.live.path)!
        }
    }
    
    var path: String {
        
        switch self {
        case .splash:
            return "x/v2/splash/list"
        case .recommendTogetherList:
            return "x/feed/index"
        case .recommendBranch:
            return "x/feed/index/tab"
        case .watchLater:
            return "x/member/v2/notice"
        case .rankWholeStation:
            return "x/v2/rank"
        case .rankRegion:
            return "x/v2/rank/region"
        case .livePartitionList:
            return "room/v1/AppIndex/getAllList"
        case .reloadRecommendPartition:
            return "room/v1/AppIndex/recRefresh"
        case .reloadCommonPartition:
            return "room/v1/Area/getRoomList"
        case .getOtherSourceRoomList:
            return "room/v1/Area/getOtherSourceRoomList"
        case .liveRecommendList:
            return "rankdb/v1/Rank2018/getRecommendList"
        case .allLive:
            return "mobile/rooms"
        case .dramaPage:
            return "appindex/follow_index_page"
        case .dramaMine:
            return "appindex/follow_index_mine"
        case .dramaFall:
            return "appindex/follow_index_fall"
        case .dramaRcmd:
            return "api/concern_recommend"
        case .dramaFollow:
            return "follow/api/season/follow"
        case .dramaUnFollow:
            return "follow/api/season/unfollow"
        case .dramaLike:
            return "api/get_concerned_season"
        }
    }
    
    var method: Moya.Method {
        switch self {
    case .splash,.recommendTogetherList,.recommendBranch,.watchLater,.rankWholeStation,.rankRegion,.livePartitionList,.reloadRecommendPartition,.reloadCommonPartition,.getOtherSourceRoomList,.liveRecommendList,.allLive,.dramaPage,.dramaMine,.dramaFall,.dramaRcmd,.dramaFollow,.dramaUnFollow,.dramaLike:
            
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
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15bf","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","id":"0","mobi_app":"iphone","platform":"ios","sign":"901747a5b6a429d230f291202dd4dbc9","ts":"1520592426"], encoding: URLEncoding.default)
        case .watchLater:
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15b","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","mid":"39225696","mobi_app":"iphone","platform":"ios","sign":"62d7090dbd7945a4611a531fee07bc46","ts":"1520589443","uuid":"8FBE4D89F6304A8EBEBE4ACEE3D43B1C"], encoding: URLEncoding.default)
        case .rankWholeStation:
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15b","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","pn":"0","ps":"100","order":"all","sign":"70cac15647144da1096a6e08552a5ae6","ts":"1524897741"], encoding: URLEncoding.default)
        case .rankRegion(let regionType):
            return .requestParameters(parameters: ["access_key":"1116bcaf932517678ab5dbae562d15b","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","pn":"0","ps":"100","rid":"\(regionType.rawValue)","sign":"70cac15647144da1096a6e08552a5ae6","ts":"1524897741"], encoding: URLEncoding.default)
            
        case .livePartitionList:
            return .requestParameters(parameters: ["access_key":"719c14ebf68fc36be6a1433c4c929058","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","mobi_app":"iphone","scale":"3","platform":"ios","sign":"93166cf9db443327dde2a1e522ee0140"], encoding: URLEncoding.default)
        case .reloadRecommendPartition:
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","mobi_app":"iphone","scale":"2","platform":"ios","sign":"86ccc56db647fbf168d5b8923450e313","ts":"1521020778"], encoding: URLEncoding.default)
        case let .reloadCommonPartition(partitionType):
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","area_id":"0", "build":"6560","cate_id":"0", "device":"phone","mobi_app":"iphone","parent_area_id":"\(partitionType.rawValue)","platform":"ios","sign":partitionSign(partitionType),"sort_type":"dynamic","ts":ts(partitionType)], encoding: URLEncoding.default)
        case let .getOtherSourceRoomList(page,pagesize):
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570", "device":"phone","mobi_app":"iphone","page":"\(page)","pageSize":"\(pagesize)",  "platform":"ios","sign":"8591952630f12e5dc60fc0b233c968e6&","sort_type":"dynamic","source_type":"source_type","ts":"1521789524"], encoding: URLEncoding.default)
        case .liveRecommendList:
            return .requestParameters(parameters: ["actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6570","device":"phone","mobi_app":"iphone","platform":"ios","sign":"86ccc56db647fbf168d5b8923450e313","ts":"1521020778"], encoding: URLEncoding.default)
        case .allLive(let subType):
            return .requestParameters(parameters: ["access_key":"ecec2f83c089316cd8cc1b9864504a90","actionKey":"appkey","appkey":"27eb53fc9058f8c3","area_id":"0","build":"6620","device":"phone","mobi_app":"iphone","page":"1","platform":"ios","sign":allSign(subType),"sort":subType.title], encoding: URLEncoding.default)
        case .dramaPage:
            return .requestParameters(parameters: ["access_key":"ecec2f83c089316cd8cc1b9864504a90","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","platform":"ios","sign":"af052f80f11c5d24b18293122bbaaf6b","ts":"1523965856"], encoding: URLEncoding.default)
        case .dramaMine:
            return .requestParameters(parameters: ["access_key":"922ba3eee4e6661a6414e665cd082351","actionKey":"appkey","appkey":"27eb53fc9058f8c3","build":"6620","device":"phone","mobi_app":"iphone","pageSize":"6","platform":"ios","sign":"e296852b5c088d058a8f8cb84e572821","ts":"1523965856"], encoding: URLEncoding.default)
        case .dramaFall(let cursor):
            return .requestParameters(parameters: ["access_key":"ecec2f83c089316cd8cc1b9864504a90","actionKey":"appkey","appkey":"27eb53fc9058f8c3","area":"0",  "build":"6620","cursor":cursor, "device":"phone","mobi_app":"iphone","pageSize":"20","platform":"ios","sign":"64b29cbcfb3aa9f573c215c52398d7b7&","ts":"1523965856"], encoding: URLEncoding.default)
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
        return ["Content-Type": "application/json"]
    }
    
    var sampleData: Data {
        return Data()
    }
    
    private func partitionSign(_ partitionType:LivePartitionType) -> String {
        
        switch partitionType {
        case .entertainment:
            return "0913930bc000b79f232a8dc580dd66fb"
        case .PCGame:
            return "155b6f442f26bccb738d324307ad2c1a"
        case .mobileGame:
            return "3c468e6331be50b937f677eb576c00b9"
        case .draw:
            return "277df99ebe5d7b9e7019c87e16c13c62"
        default:
            return ""
        }
    }
    
    private func ts(_ partitionType:LivePartitionType) -> String {
        switch partitionType {
        case .entertainment:
            return "1519797208"
        case .PCGame:
            return "1519797320"
        case .mobileGame:
            return "1519797398"
        case .draw:
            return "1519797965"
        default:
            return ""
        }
    }
    
    private func allSign(_ subType: LiveAllSubType) -> String {
        switch subType {
        case .suggestion:
            return "20d3d2c6c6ab4516846474d9dafa7329"
        case .hottest:
            return "601836cd52051dbcba792220dc7c3785"
        case .latest:
            return "7644428211e24cd2cce4200c95379d84"
        case .roundroom:
            return "dd16d5c3da2516cefa9b5e4ad4c12248&"
        }
    }
    
}
