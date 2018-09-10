//
//  DramaViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit
import RxSwift
import RxCocoa

import Dollar

final class DramaViewReactor: Reactor,OutputRefreshProtocol {

    enum Action {
        case refresh
        case updateMineDrama
        case loadMore
    }
    
    enum Mutation {
        case setLoading(Bool)
        case setRefresh(DramaPageModel)
        case setDrama(DramaMineModel)
        case appendFoots([DramaItemModel])
    }
    
    struct State {
        var isLoading: Bool = false
        var pageModel: LiveTotalModel?
        var sections: [DramaViewSection]?
    }
    
    let initialState: State
    let service: HomeServiceType
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>
    
    private var footModels: [DramaItemModel]?
    private var isAllowLoad: Bool = true
    
    init(service:HomeServiceType) {
        defer { _ = self.state }
        self.service = service
        self.initialState = State()
        self.refreshStatus = BehaviorRelay<BilibiliRefreshStatus>(value: .none)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        switch action {
        case .refresh:
            return service.dramaPage().asObservable().map{.setRefresh($0)}
        case .updateMineDrama:
            return .empty()
            //return service.dramaMine().asObservable().map{.setDrama($0)}
        case .loadMore:
             return .empty()
//            guard self.currentState.isLoading == false,
//                  self.isAllowLoad == true,
//                  let footModels = self.footModels,
//                  let lastFootModel = footModels.last,
//                  let cursor = lastFootModel.cursor
//            else { return .empty() }
//
//            let startLoading = Observable.just(Mutation.setLoading(true))
//            let endLoading = Observable.just(Mutation.setLoading(false))
//            let appendFoots = service.dramaFall(cursor: "\(cursor)").asObservable().map{Mutation.appendFoots($0)}
//            return Observable.concat([startLoading,appendFoots,endLoading])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setRefresh(pageModel):
            self.refreshStatus.accept(.endHeaderRefresh)
            //self.footModels = pageModel.modules
            //let pageModel = handleBottomLine(pageModel: pageModel)
            self.footModels = pageModel.modules.last?.items
            
            let resultModule = pageModel.modules.filter{!$0.items.isEmpty}
            
            state.sections = resultModule.map({ (moduleModel) -> DramaViewSection in
                
                var moduleModel = moduleModel
                if let headers = moduleModel.headers,!headers.isEmpty {
                    moduleModel.headers![0].name = moduleModel.title
                }
                let sectionReactor = DramaSectionReactor(moduleModel: moduleModel)
                let section = DramaViewSection(headerModel: moduleModel.headers?.first, items: sectionReactor.currentState.sectionItems.map{DramaViewSectionItem.drama($0)})
                return section
            })
//            if let mineSection = mineSection(mineModel.follows) {
//                if state.sections?.count == 5 {
//                    state.sections?[0] = mineSection
//                }else{
//                    state.sections?.insert(mineSection, at: 0)
//                }
//            }
        case .setDrama(let mineModel):
            if let mineSection = mineSection(mineModel.follows) {
                if state.sections?.count == 5 {
                    state.sections?[0] = mineSection
                }else{
                    state.sections?.insert(mineSection, at: 0)
                }
            }else{
                if state.sections?.count == 5 {
                    state.sections?.remove(at: 0)
                }
            }
        case let .setLoading(isLoading):
            state.isLoading = isLoading
        case .appendFoots(let footModels):
            isAllowLoad = footModels.count != 0
//            if var oldFootModels = self.footModels {
//                oldFootModels += footModels
//                self.footModels = oldFootModels
//                let currentSection = editSection(oldFootModels)
//                state.sections![state.sections!.count - 1] = currentSection
//            }
        }
        return state
    }
    
//    private func handleBottomLine(pageModel:DramaPageModel) -> DramaPageModel {
//
//        var pageModel = pageModel
//
//        for (i,var review) in pageModel.recommend_review.enumerated() {
//            if i == pageModel.recommend_review.count - 1 {
//                review.isShowBottomLine = false
//                pageModel.recommend_review[i] = review
//            }
//        }
//
//        return pageModel
//    }
    
    private func mineSection(_ followModels:[DramaFollowModel]) -> DramaViewSection? {

//        if followModels.count != 0 {
//
//            let follows = Dollar.chunk(followModels, size: 3).first!
//
//            let sectionReactor = DramaSectionReactor(followModels: follows)
//            let section = DramaViewSection(headerModel: DramaHeaderModel(icon: Image.Home.dramaRcmd, name: DramaSectionType.mine.title, type: .mine), items: sectionReactor.currentState.sectionItems.map{DramaViewSectionItem.drama($0)})
//            return section
//        }
        return nil
    }
}
