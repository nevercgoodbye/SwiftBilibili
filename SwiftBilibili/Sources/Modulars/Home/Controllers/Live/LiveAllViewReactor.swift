//
//  LiveAllViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

final class LiveAllViewReactor: Reactor,OutputRefreshProtocol {

    enum Action {
        case refresh
        case loadMore
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setRefresh([LiveAvModel])
        case appendAvs([LiveAvModel])
    }
    
    struct State {
        var isLoading: Bool = false
        var avModels: [LiveAvModel] = []
        var sections: [LiveAllViewSection]?
        var page: Int = 1
    }
    let initialState: State
    let homeService: HomeServiceType
    let subType: LiveAllSubType
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>
    
    init(homeService:HomeServiceType,subType:LiveAllSubType) {
        defer { _ = self.state }
        self.homeService = homeService
        self.subType = subType
        self.initialState = State()
        self.refreshStatus = BehaviorRelay<BilibiliRefreshStatus>(value: .none)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh:
            return homeService.liveAll(subType: subType, page: 1).asObservable().map{.setRefresh($0.map{LiveAvModel(allModel: $0)})}
            
        case .loadMore:
            if self.currentState.isLoading { return .empty() }
            let startLoading = Observable.just(Mutation.setLoading(true))
            let endLoading = Observable.just(Mutation.setLoading(false))
            let appendAvs = homeService.liveAll(subType: subType, page: currentState.page+1).asObservable().map{Mutation.appendAvs($0.map{LiveAvModel(allModel: $0)})}
            return Observable.concat([startLoading,appendAvs,endLoading])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setRefresh(let avModels):
            state.avModels.removeAll(keepingCapacity: false)
            self.refreshStatus.accept(.endHeaderRefresh)
            state.page = 1
            state.avModels = handleAvModels(avModels: avModels)
            state.sections = [.all(getSectionItems(avModels: state.avModels))]
        case .appendAvs(let avModels):
            state.page += 1
            state.avModels += handleAvModels(avModels: avModels)
            state.sections = [.all(getSectionItems(avModels: state.avModels))]
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
    }
    
    private func handleAvModels(avModels:[LiveAvModel]) -> [LiveAvModel] {
        
        var tempModels:[LiveAvModel] = []
        for i in 0..<avModels.count {
            var avModel = avModels[i]
            if i%2 != 0 { avModel.isLeft = false }
            tempModels.append(avModel)
        }
        return tempModels
    }
    
    
    private func getSectionItems(avModels:[LiveAvModel]) -> [LiveAllViewSectionItem] {
        
        if self.subType == .roundroom {
            return avModels.map{LiveRoundRoomCellReactor(live: $0)}.map{LiveAllViewSectionItem.roundRoom($0)}
        }else{
            return avModels.map{LiveAvCellReactor(live: $0)}.map{LiveAllViewSectionItem.av($0)}
        }
    }
}
