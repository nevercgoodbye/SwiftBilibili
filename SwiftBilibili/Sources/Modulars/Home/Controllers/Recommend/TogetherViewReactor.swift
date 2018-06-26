//
//  TogetherViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit
import RxSwift
import Dollar
import SwiftyUserDefaults
import RxCocoa

final class TogetherViewReactor: Reactor,OutputRefreshProtocol {
    
    enum Action {
        case refresh(TogetherRefreshType,Bool)//Bool用来判断是否是第一次请求
        case loadMore
        case showAd //展示广告 --
        /** 1.取出缓存里开始时间小于现在且结束时间大于现在的数据展示
            2.把缓存里结束时间超过现在的删除
            3.将模型里show字段下的数据都存下来
        */
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setTogethers([RecommendTogetherModel],Bool)
        case appendTogethers([RecommendTogetherModel])
        case setDislike(Int?,TogetherDislikeModel?,Bool)
        case setWatchLater(Int,Bool)
        case setMove(Int)
        case setAd(ListRealmModel)
//        case refreshError
//        case loadMoreError
    }
    
    struct State {
        var isLoading: Bool = false
//        var isRefreshFailue: Bool = false
//        var isLoadMoreFailue: Bool = false
        var moveCount: Int?
        var togetherModels: [RecommendTogetherModel] = []
        var sections: [TogetherViewSection]?
        var adModel: ListRealmModel?
    }
    let initialState: State
    let homeService: HomeServiceType
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>
    private var hash: String = ""
    init(homeService:HomeServiceType) {
        defer { _ = self.state }
        self.homeService = homeService
        self.initialState = State()
        self.refreshStatus = BehaviorRelay<BilibiliRefreshStatus>(value: .none)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .refresh(refreshType,firstLoad):
          let count = currentState.togetherModels.count
          if count != 0 {
            guard let refreshIdx = currentState.togetherModels.first?.idx else {
                return .empty()
            }
            Defaults[.avIdx] = "\(refreshIdx)"
          }
          return homeService.recommendTogetherList(refreshType: refreshType, idx:       Defaults[.avIdx],firstLoad: firstLoad,hash:self.hash)
              .asObservable()
              .map{.setTogethers($0,firstLoad)}
//              .catchError({ (error) -> Observable<TogetherViewReactor.Mutation> in
//                if let firstLoad = firstLoad,!firstLoad {
//                    return Observable.just(Mutation.refreshError)
//                }
//                return Observable.empty()
//             })
        case .loadMore:
            guard self.currentState.isLoading == false,
                  let loadIdx = currentState.togetherModels.last?.idx
            else {
                return .empty()
            }
            let startLoading = Observable.just(Mutation.setLoading(true))
            let endLoading = Observable.just(Mutation.setLoading(false))
            let appendTogethers = homeService.recommendTogetherList(refreshType: .loadMore, idx: "\(loadIdx)",firstLoad:false,hash:self.hash).asObservable().map{Mutation.appendTogethers($0)}//.catchErrorJustReturn(.loadMoreError)
            return Observable.concat([startLoading,appendTogethers,endLoading])
        case .showAd:
            
            let currentTime = Int(Date().timeIntervalSince1970)
            let storeModels = RealmManager.selectByAll(ListRealmModel.self)
            let showModels = storeModels.filter{$0.begin_time<=currentTime&&$0.end_time>currentTime}
            _ = homeService.splash().asObservable().subscribe(onNext: { (splashModel) in
                let deleteModels = storeModels.filter{$0.end_time >= currentTime}
                var realmModels: [ListRealmModel] = []
                deleteModels.forEach({ (model) in
                    realmModels.append(model)
                })
                if realmModels.count > 0 {
                    realmModels.forEach{ImageManager.removeImage(key: $0.thumb)}
                    RealmManager.delete(realmModels)
                }
                guard let sysShows = splashModel.show else { return }
                
                let showIds = sysShows.map{$0.id}
                let needStoreModels = splashModel.list.filter{showIds.contains($0.id)}
                if needStoreModels.count > 0 {
                    var listRealmModels: [ListRealmModel] = []
                    needStoreModels.forEach({ (list) in
                        let listRealmModel = ListRealmModel()
                        listRealmModel.storge(list: list)
                        listRealmModels.append(listRealmModel)
                        ImageManager.storeImage(urlString: list.thumb, completionHandler: {
                            log.info("图片存储成功了")
                        })
                    })
                    RealmManager.addListData(listRealmModels)
                }
            })
            
            if showModels.count > 0 {
                let showModel = showModels.last!
                return Observable.just(Mutation.setAd(showModel))
            }else{
                return Observable.empty()
            }
        }
  }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setTogethers(togetherModels,firstLoad):
            self.refreshStatus.accept(.endHeaderRefresh)
            if self.hash.isEmpty {
                 self.hash = togetherModels.filter{$0.goto == .banner}.first?.hash ?? ""
            }
            //state.isRefreshFailue = false
            if firstLoad {
               state.moveCount = togetherModels.count
            }
            state.togetherModels = updateTogethersForTip(requestTogethers: togetherModels, totalTogethers: state.togetherModels)
            let togetherSectionReactor = TogetherSectionReactor(togetherModels: state.togetherModels)
            state.sections = [.together(togetherSectionReactor.currentState.sectionItems.map(TogetherViewSectionItem.together))]
            return state
        case let .setLoading(isLoading):
            state.isLoading = isLoading
            return state
        case let .appendTogethers(togetherModels):
            //state.isLoadMoreFailue = false
            state.togetherModels = state.togetherModels + togetherModels
            let togetherSectionReactor = TogetherSectionReactor(togetherModels: state.togetherModels)
            state.sections = [.together(togetherSectionReactor.currentState.sectionItems.map(TogetherViewSectionItem.together))]
            return state
        case let .setDislike(idx,dislikeModel,isDelete):
            
            let index = Dollar.findIndex(state.togetherModels, callback: {$0.idx == idx})
            
            if isDelete {
                if let index = index {
                    state.togetherModels.remove(at: index)
                    state.sections?.remove(at: IndexPath(item: index, section: 0))
                }
            }else{
                
                let togetherModel = state.togetherModels.filter{$0.idx == idx}.first
                if var togetherModel = togetherModel,let index = index {
                    togetherModel.isDislike = dislikeModel == nil ? false : true
                    togetherModel.dislikeRecordTime = dislikeModel == nil ? nil : Date()
                    togetherModel.dislikeName = dislikeModel?.reason_name
                    
                    state.togetherModels[index] = togetherModel
                    let togetherSectionReactor = TogetherSectionReactor(togetherModels: state.togetherModels)
                    state.sections = [.together(togetherSectionReactor.currentState.sectionItems.map(TogetherViewSectionItem.together))]
             }

            }
            return state
        case let .setWatchLater(idx,isCancle):
            
            if !isCancle { BilibiliToaster.show("添加成功") }
            let togetherModel = state.togetherModels.filter{$0.idx == idx}.first
            let index = Dollar.findIndex(state.togetherModels, callback: {$0.idx == idx})
            if var togetherModel = togetherModel, let index = index {
                togetherModel.isSetWatchLater = !togetherModel.isSetWatchLater
                state.togetherModels[index] = togetherModel
                let togetherSectionReactor = TogetherSectionReactor(togetherModels: state.togetherModels)
                state.sections = [.together(togetherSectionReactor.currentState.sectionItems.map(TogetherViewSectionItem.together))]
            }
            return state
        case let .setMove(count):
            state.moveCount = count
            return state
        case .setAd(let adModel):
            state.adModel = adModel
            return state
//        case .refreshError:
//            if state.isLoadMoreFailue {
//                state.isLoadMoreFailue = false
//            }
//            state.isRefreshFailue = true
//            return state
//        case .loadMoreError:
//            if state.isRefreshFailue {
//                state.isRefreshFailue = false
//            }
//            state.isLoadMoreFailue = true
//            return state
        }
        
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        
        let eventMutation = RecommendTogetherModel.event.flatMap {[weak self] togetherEvent -> Observable<Mutation> in
            self?.mutate(event: togetherEvent) ?? .empty()
        }
        
        return Observable.of(mutation,eventMutation).merge()
    }
    
    //Private method
    private func mutate(event:RecommendTogetherModel.Event) -> Observable<Mutation> {
        
        switch event {
        case let .cacheTogethers(togethers):
           if currentState.togetherModels.count != 0 { return .empty() }
           return .just(.setTogethers(togethers,false))
            
        case let .dislikeReason(dislikeIdx,dislikeModel,isDelete):
           //1.发送网络请求。-- 没有接口
            
           //2.更改模型刷新界面
           return .just(.setDislike(dislikeIdx,dislikeModel,isDelete))
        case let .watchLater(idx,isCancle):
           guard let idx = idx else { return .empty() }
           //随便写的接口 当取消稍后观看时只需更新UI
           if isCancle {
             return Observable.just(Mutation.setWatchLater(idx,true))
           }else{
             return homeService.watchLater(idx: "\(idx)").asObservable().map{.setWatchLater(idx,false)}
           }
        }
    }
    
    private func updateTogethersForTip(requestTogethers:[RecommendTogetherModel],
                                            totalTogethers:[RecommendTogetherModel])
        -> [RecommendTogetherModel] {
        
        let totalCount = totalTogethers.count
            
        if totalCount == 0 { return requestTogethers + totalTogethers}
        
        var requestTogethers = requestTogethers
        var totalTogethers = totalTogethers
        
        requestTogethers.append(RecommendTogetherModel(isShowTip:true))
            
        let tipCount = totalTogethers.filter{$0.isShowTip}.count
        
        if tipCount != 0 {
            let index = Dollar.findIndex(totalTogethers, callback: {$0.isShowTip})!
            totalTogethers.remove(at: index)
        }
        return requestTogethers + totalTogethers
    }
    
}
