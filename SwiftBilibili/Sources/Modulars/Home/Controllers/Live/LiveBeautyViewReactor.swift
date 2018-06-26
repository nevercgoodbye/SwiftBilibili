//
//  LiveBeautyViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/23.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

final class LiveBeautyViewReactor: Reactor,OutputRefreshProtocol {

    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setRefresh([LivePartitionAvModel])
    }
    
    struct State {
        var sections: [LiveBeautyViewSection] = []
    }
    
    let initialState: State
    let service: HomeServiceType
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus> = BehaviorRelay(value: .none)
    
    init(service:HomeServiceType) {
        defer { _ = self.state }
        self.service = service
        self.initialState = State()
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
           return service.getOtherSourceRoomList(page:1,pageSize:20).asObservable().map{Mutation.setRefresh($0)}
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        var state = state
        
        switch mutation {
        case .setRefresh(let lives):
            self.refreshStatus.accept(.endHeaderRefresh)
            state.sections = [.beauty(lives.map{.beauty(LiveBeautyCellReactor(live: $0))})]
        }
        
        return state
    }
}
