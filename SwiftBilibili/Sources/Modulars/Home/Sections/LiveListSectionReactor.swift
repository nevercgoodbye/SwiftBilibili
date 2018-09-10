//
//  LiveListSectionReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SectionReactor
import RxSwift
import Dollar

final class LiveListSectionReactor: SectionReactor {

    enum SectionItem {
        case av(LiveAvCellReactor)
        case hourRank
    }
    
    enum Action {}
    
    enum Mutation {
        case refreshPartition(Int,[LiveAvModel],Bool)//1.刷新的数据对应的moduleId 2.需要更新的数据 3.是否发起网络请求替换存储的数据
    }

    
    struct State: SectionReactorState {
        var module: LiveModuleListModel
        var sectionItems: [SectionItem]
    }
    
    private let homeService: HomeServiceType = HomeService(networking: HomeNetworking())
    
    private var storeAvModels: [[LiveAvModel]] = []
    
    var bannerModels: [LiveAvModel]?
    var regionModels: [LiveAvModel]?
    var tagModels: [LiveTagModel]?
    
    let initialState: State

    init(module:LiveModuleListModel) {
        
        defer { _ = self.state }
        
        var sectionItems: [SectionItem] = []
        
        if module.module_info.id == hourRankModuleId {
              sectionItems.append(.hourRank)
        }else{
              let size = module.module_info.id == rcmdModuleId ? 6 : 4
              var avModels: [LiveAvModel] = []
              let s = Dollar.chunk(module.list, size: size)
              avModels = s[0]
              storeAvModels = Array(s.dropFirst())
            
              for i in 0..<avModels.count {
                 var avModel = avModels[i]
                 if i%2 != 0 {avModel.isLeft = false}
                 sectionItems.append(.av(LiveAvCellReactor(live: avModel)))
              }
          }
            self.initialState = State(module: module, sectionItems: sectionItems)
    }

    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let fromEvent = LiveTotalModel.event.flatMap { [weak self] event -> Observable<Mutation> in
            guard let `self` = self else { return .empty() }
            switch event {
            case .exchange(let moduleId):
                guard moduleId == self.currentState.module.module_info.id else { return .empty() }
                if self.storeAvModels.isNotEmpty {
                    log.info("我被执行了")
                    let showAvModels = self.storeAvModels[0]
                    self.storeAvModels = Array(self.storeAvModels.dropFirst())
                    return Observable.just(Mutation.refreshPartition(moduleId,showAvModels,false))
                }else{
                    return self.homeService.liveModuleList(moduleId: moduleId).asObservable().map{Mutation.refreshPartition(moduleId,$0.module_list[0].list,true)}
                }
            }
        }
        return Observable.merge(mutation, fromEvent)
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        switch mutation {
        case let .refreshPartition(moduleId,avModels,isReplace):
            let delayTime = isReplace ? kLivePartitionRefreshRotationTime/2 : kLivePartitionRefreshRotationTime
            DispatchQueue.delay(time: delayTime, action: {
                NotificationCenter.post(customNotification: .stopRotate)
            })
            if avModels.count == 0 { return state }
            state.sectionItems.removeAll()
            var showAvModels = avModels
            
            if isReplace {
                 let size = moduleId == rcmdModuleId ? 6 : 4
                 let s = Dollar.chunk(avModels, size: size)
                 showAvModels = s[0]
                 self.storeAvModels = Array(s.dropFirst())
            }
            
            for i in 0..<showAvModels.count {
                var avModel = avModels[i]
                if i%2 != 0 {avModel.isLeft = false}
                state.sectionItems.append(.av(LiveAvCellReactor(live: avModel)))
            }
         }
        return state
    }
}
