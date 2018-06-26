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
    
    //启动页
    func splash() -> Single<SplashModel>
    
    //推荐
    func recommendTogetherList(refreshType:TogetherRefreshType,idx:String,firstLoad:Bool,hash:String) -> Single<[RecommendTogetherModel]>
    func recommendBranch() -> Single<RecommendBranchModel>
    func watchLater(idx:String) -> Single<Void>
    func rankWholeStation() -> Single<RankModel>
    func rankRegion(regionType: RankRegionType) -> Single<[RankChildrenModel]>
    //直播
    func livePartitionList() -> Single<LiveTotalModel>
    func liveRecommendList() -> Single<[LiveStarShowModel]>
    func reloadRecommendPartition() -> Single<LiveRecommendModel>
    func reloadCommonPartition(partitionType:LivePartitionType) -> Single<[LivePartitionAvModel]>
    func getOtherSourceRoomList(page:Int,pageSize:Int) -> Single<[LivePartitionAvModel]>
    func liveAll(subType:LiveAllSubType) -> Single<[LiveRecommendAvModel]>
    //番剧
    func dramaPage() -> Single<DramaPageModel>
    func dramaFall(cursor:String) -> Single<[DramaFootModel]>
    func dramaMine() -> Single<DramaMineModel>
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
    
    func watchLater(idx: String) -> Single<Void> {
        return networking.request(.watchLater(idx: idx)).map{ _ in }.handleError()
    }
    
    func rankWholeStation() -> Single<RankModel> {
        return networking.request(.rankWholeStation).map(RankModel.self)
    }
    
    func rankRegion(regionType: RankRegionType) -> Single<[RankChildrenModel]> {
        return networking.request(.rankRegion(regionType: regionType)).map(RankChildrenModel.self)
    }
    
    func livePartitionList() -> Single<LiveTotalModel> {
        return networking.request(.livePartitionList).map(LiveTotalModel.self)
    }
    
    func liveRecommendList() -> Single<[LiveStarShowModel]> {
        return networking.request(.liveRecommendList).map(LiveStarShowModel.self)
    }
    
    func reloadRecommendPartition() -> Single<LiveRecommendModel> {
        return networking.request(.reloadRecommendPartition).map(LiveRecommendModel.self)
    }
    
    func reloadCommonPartition(partitionType:LivePartitionType) -> Single<[LivePartitionAvModel]> {
        return networking.request(.reloadCommonPartition(partitionType)).map(LivePartitionAvModel.self)
    }
    
    func getOtherSourceRoomList(page:Int,pageSize:Int) -> Single<[LivePartitionAvModel]> {
        
        return networking.request(.getOtherSourceRoomList(page:page,pageSize:pageSize)).map(LivePartitionAvModel.self)
    }
    
    func liveAll(subType:LiveAllSubType) -> Single<[LiveRecommendAvModel]> {
        return networking.request(.allLive(subType: subType)).map(LiveRecommendAvModel.self)
    }
    
    func dramaPage() -> Single<DramaPageModel> {
        
        return networking.request(.dramaPage).map(DramaPageModel.self)
    }
    
    func dramaFall(cursor:String) -> Single<[DramaFootModel]> {
        
        return networking.request(.dramaFall(cursor: cursor)).map(DramaFootModel.self)
    }
    
    func dramaMine() -> Single<DramaMineModel> {
        return networking.request(.dramaMine).map(DramaMineModel.self).handleError()
    }
    
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
