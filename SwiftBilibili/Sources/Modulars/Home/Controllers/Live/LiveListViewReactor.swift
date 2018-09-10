//
//  LiveListViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

final class LiveListViewReactor: Reactor,OutputRefreshProtocol {

    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setRefresh(LiveTotalModel,LiveUserSettingModel)
    }
    
    struct State {
        fileprivate var liveSectionReactors: [LiveListSectionReactor] = []
        var sections: [LiveListViewSection] {
            return self.liveSectionReactors.map(LiveListViewSection.live)
        }
    }
    let initialState: State
    private let service: HomeServiceType
    private let liveSectionReactorFactory: (LiveModuleListModel) -> LiveListSectionReactor
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>

    private var moduleList: [LiveModuleListModel] = []
    
    init(service:HomeServiceType,
         liveSectionReactorFactory: @escaping (LiveModuleListModel) -> LiveListSectionReactor
        )
    {
        defer { _ = self.state }
        self.service = service
        self.liveSectionReactorFactory = liveSectionReactorFactory
        self.initialState = State()
        self.refreshStatus = BehaviorRelay<BilibiliRefreshStatus>(value: .none)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return Observable.zip(service.liveModuleList(moduleId:0).asObservable(), service.liveUserSetting().asObservable(), resultSelector: { (s1, s2) -> Mutation in
                return Mutation.setRefresh(s1, s2)
            })
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setRefresh(totalModel,settingModel):
            self.refreshStatus.accept(.endHeaderRefresh)
            let moduleList = totalModel.module_list.filter{$0.module_info.id != bannerModuleId && $0.module_info.id != regionModuleId && $0.list.isNotEmpty}
            state.liveSectionReactors = moduleList.map(self.liveSectionReactorFactory)
            state.liveSectionReactors.forEach { (sectionReactor) in
                let moduleId = sectionReactor.currentState.module.module_info.id
                if moduleId == rcmdModuleId {
                    sectionReactor.bannerModels = totalModel.module_list.filter{$0.module_info.id == bannerModuleId}.first?.list ?? []
                    sectionReactor.regionModels = totalModel.module_list.filter{$0.module_info.id == regionModuleId}.first?.list ?? []
                    sectionReactor.tagModels = settingModel.tags
                }
            }
        }
        return state
    }
    func transform(state: Observable<State>) -> Observable<State> {
        return state.with(section: \.liveSectionReactors)
    }
}
