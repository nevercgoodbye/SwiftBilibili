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
        case setRefresh(DramaPageModel,[DramaFootModel],DramaMineModel)
        case setDrama(DramaMineModel)
        case appendFoots([DramaFootModel])
        case requestError
    }
    
    struct State {
        var isLoading: Bool = false
        var isSuccess: Bool = true
        var pageModel: LiveTotalModel?
        var sections: [DramaViewSection]?
    }
    
    let initialState: State
    let service: HomeServiceType
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>
    
    private var footModels: [DramaFootModel]?
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
            let pageRequest = service.dramaPage().asObservable()
            let fallRequest = service.dramaFall(cursor: "").asObservable()
            let mineRequest = service.dramaMine().asObservable()
            return Observable.zip(pageRequest, fallRequest,mineRequest, resultSelector: { (os1, os2,os3) -> Mutation in
                return Mutation.setRefresh(os1,os2,os3)
            }).catchErrorJustReturn(Mutation.requestError)
        case .updateMineDrama:
            return service.dramaMine().asObservable().map{.setDrama($0)}
            
        case .loadMore:
            
            guard self.currentState.isLoading == false,
                  self.isAllowLoad == true,
                  let footModels = self.footModels,
                  let lastFootModel = footModels.last,
                  let cursor = lastFootModel.cursor
            else { return .empty() }
            
            let startLoading = Observable.just(Mutation.setLoading(true))
            let endLoading = Observable.just(Mutation.setLoading(false))
            let appendFoots = service.dramaFall(cursor: "\(cursor)").asObservable().map{Mutation.appendFoots($0)}
            return Observable.concat([startLoading,appendFoots,endLoading])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case let .setRefresh(pageModel, footModels, mineModel):
            self.refreshStatus.accept(.endHeaderRefresh)
            self.footModels = footModels
            let pageModel = handleBottomLine(pageModel: pageModel)
            let firstSection = dramaSection(pageModel.recommend_jp)
            let secondSection = countrySection(pageModel.recommend_cn)
            let threeSection = reviewSection(pageModel.recommend_review)
            let fourSection = editSection(footModels)
            state.sections = [firstSection,secondSection,threeSection,fourSection]
            state.isSuccess = true
            if let mineSection = mineSection(mineModel.follows) {
                if state.sections?.count == 5 {
                    state.sections?[0] = mineSection
                }else{
                    state.sections?.insert(mineSection, at: 0)
                }
            }
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
            if var oldFootModels = self.footModels {
                oldFootModels += footModels
                self.footModels = oldFootModels
                let currentSection = editSection(oldFootModels)
                state.sections![state.sections!.count - 1] = currentSection
            }
        case .requestError:
            state.isSuccess = false
        }
        return state
    }
    
    private func handleBottomLine(pageModel:DramaPageModel) -> DramaPageModel {
        
        var pageModel = pageModel
        
        for (i,var review) in pageModel.recommend_review.enumerated() {
            if i == pageModel.recommend_review.count - 1 {
                review.isShowBottomLine = false
                pageModel.recommend_review[i] = review
            }
        }
        
        return pageModel
    }
    
    private func mineSection(_ followModels:[DramaFollowModel]) -> DramaViewSection? {

        if followModels.count != 0 {
            
            let follows = Dollar.chunk(followModels, size: 3).first!
            
            let sectionReactor = DramaSectionReactor(followModels: follows)
            let section = DramaViewSection(headerModel: DramaHeaderModel(icon: Image.Home.dramaRcmd, name: DramaSectionType.mine.title, type: .mine), items: sectionReactor.currentState.sectionItems.map{DramaViewSectionItem.drama($0)})
            return section
        }
        return nil
    }
    
    private func dramaSection(_ cnModel:DramaCnModel) -> DramaViewSection {
        let sectionReactor = DramaSectionReactor(cnModel: cnModel)
        let section = DramaViewSection(headerModel: DramaHeaderModel(icon: Image.Home.dramaRcmd, name: DramaSectionType.drama.title, type: .drama), items: sectionReactor.currentState.sectionItems.map{DramaViewSectionItem.drama($0)})
        return section
    }
    
    private func countrySection(_ cnModel:DramaCnModel) -> DramaViewSection {
        let sectionReactor = DramaSectionReactor(cnModel: cnModel)
        let section = DramaViewSection(headerModel: DramaHeaderModel(icon: Image.Home.countryRcmd, name: DramaSectionType.country.title, type: .country), items: sectionReactor.currentState.sectionItems.map{DramaViewSectionItem.drama($0)})
        return section
    }
    
    private func editSection(_ footModels:[DramaFootModel]) -> DramaViewSection {
        let sectionReactor = DramaSectionReactor(footModels: footModels)
        let section = DramaViewSection(headerModel: DramaHeaderModel(icon: Image.Home.editRcmd, name: DramaSectionType.edit.title, type: .edit), items: sectionReactor.currentState.sectionItems.map{DramaViewSectionItem.drama($0)})
        return section
    }
    
    private func reviewSection(_ reviewModels:[DramaReviewModel]) -> DramaViewSection {
        let sectionReactor = DramaSectionReactor(reviewModels: reviewModels)
        let section = DramaViewSection(headerModel: DramaHeaderModel(icon: Image.Home.reviewRcmd, name: DramaSectionType.review.title, type: .review), items: sectionReactor.currentState.sectionItems.map{DramaViewSectionItem.drama($0)})
        return section
    }
}
