//
//  HomeService.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import RxSwift
import SwiftyJSON

protocol HomeServiceType {

    //var liveTotalModels: Observable<[LiveTotalModel]> { get }
    
    //启动页
    func splash() -> Single<SplashModel>
    
    //推荐
    func recommendTogetherList(refreshType:TogetherRefreshType,idx:String,firstLoad:Bool,hash:String) -> Single<[RecommendTogetherModel]>
    func recommendBranch() -> Single<RecommendBranchModel>
    func watchLater(idx:String) -> Single<Void>
    func rankWholeStation() -> Single<RankModel>
    func rankRegion(regionType: RankRegionType) -> Single<[RankChildrenModel]>
    //标题栏其余数据(除直播，推荐，追番)
    func BranchData(id:Int) -> Single<BranchDataModel>
    
    //直播
    func liveModuleList(moduleId:Int) ->Single<LiveTotalModel>
    func liveUserSetting() -> Single<LiveUserSettingModel>
    func liveAll(subType:LiveAllSubType,page:Int) -> Single<[LiveAllModel]>
    //番剧
    func dramaPage() -> Single<DramaPageModel>
    func dramaFall(cursor:String) -> Single<[DramaItemModel]>
    //func dramaMine() -> Single<DramaMineModel>
    func dramaRcmd() -> Single<[DramaRecommendModel]>
    func dramaFollow(season_id:String,season_type:String) -> Single<Void>
    func dramaUnFollow(season_id:String,season_type:String) -> Single<Void>
    func dramaLike(page:Int) -> Single<[DramaLikeModel]>
}

final class HomeService: HomeServiceType {

    private let networking : HomeNetworking
    
    init(networking:HomeNetworking) {
        self.networking = networking
    }
    
    func splash() -> Single<SplashModel> {
        return networking.request(.splash).map(SplashModel.self)
    }
    
    //B站的缓存策略是只缓存综合的数据且当请求失败的时候才使用缓存数据，并不是先展示缓存数据 -- 结构体不能使用realm缓存，用class就不用这么麻烦
    func recommendTogetherList(refreshType: TogetherRefreshType, idx: String,firstLoad:Bool,hash:String) -> Single<[RecommendTogetherModel]> {
        return networking.request(.recommendTogetherList(refreshType: refreshType, idx: idx,hash: hash)).do(onSuccess: { (response) in
            //成功且下拉才缓存
            if refreshType == .loadMore { return }
            let json = try JSON(data: response.data)
            let jsonArray = json[RESULT_DATA].arrayObject!
            let data = try! JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
            let cacheModel = TogetherRealmModel()
            cacheModel.data = data
            cacheModel.key = NSStringFromClass(TogetherRealmModel.self)
            RealmManager.addCanUpdate(cacheModel)
        }, onError: { (error) in
            guard let result = RealmManager.selectByAll(TogetherRealmModel.self).first,
                  let cacheData = result.data
            else { return }
            let cacheTogethers = cacheData.cacheArray(RecommendTogetherModel.self).filter{$0.goto != .banner}
            RecommendTogetherModel.event.onNext(.cacheTogethers(togethers:cacheTogethers))
        }).map(RecommendTogetherModel.self)
    }
    
    func recommendBranch() -> Single<RecommendBranchModel> {
        return networking.request(.recommendBranch).map(RecommendBranchModel.self)
    }
    
    func BranchData(id:Int) -> Single<BranchDataModel> {
        return networking.request(.branchData(id: id)).map(BranchDataModel.self)
    }
    
    func watchLater(idx: String) -> Single<Void> {
        return networking.request(.watchLater(idx: idx)).map{ _ in }.handleError()
    }
    
    func rankWholeStation() -> Single<RankModel> {
        return networking.request(.rankWholeStation).map(RankModel.self)
    }
    
    func rankRegion(regionType: RankRegionType) -> Single<[RankChildrenModel]> {
        return networking.request(.rankRegion(regionType: regionType)).map(RankChildrenModel.self)
    }
    
    func liveModuleList(moduleId:Int) ->Single<LiveTotalModel> {
        return networking.request(.liveModuleList(moduleId:moduleId)).map(LiveTotalModel.self)
    }
    
    func liveUserSetting() -> Single<LiveUserSettingModel>  {
        return networking.request(.liveUserSetting).map(LiveUserSettingModel.self)
    }
    
    
    func liveAll(subType:LiveAllSubType,page:Int) -> Single<[LiveAllModel]> {
        return networking.request(.liveTotal(subType: subType, page: page)).map(LiveAllModel.self)
    }
    
    func dramaPage() -> Single<DramaPageModel> {
        return networking.request(.dramaPage).map(DramaPageModel.self)
    }
    
    func dramaFall(cursor:String) -> Single<[DramaItemModel]> {
        
        return networking.request(.dramaFall(cursor: cursor)).map(DramaItemModel.self)
    }
    
//    func dramaMine() -> Single<DramaMineModel> {
//        return networking.request(.dramaMine).map(DramaMineModel.self).handleError(DramaMineModel())
//    }
    
    func dramaRcmd() -> Single<[DramaRecommendModel]> {
        return networking.request(.dramaRcmd).map(DramaRecommendModel.self)
    }
    
    func dramaFollow(season_id:String,season_type:String) -> Single<Void> {
        return networking.request(.dramaFollow(season_id: season_id, season_type: season_type)).map{_ in}
    }
    func dramaUnFollow(season_id:String,season_type:String) -> Single<Void> {
        return networking.request(.dramaUnFollow(season_id: season_id, season_type: season_type)).map{_ in}
    }
    
    func dramaLike(page:Int) -> Single<[DramaLikeModel]> {
        return networking.request(.dramaLike(page: page)).map(DramaLikeModel.self)
    }
}
