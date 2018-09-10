//
//  BranchViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/9.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

final class BranchViewReactor: Reactor,OutputRefreshProtocol {

    enum Action {
        case refresh(id:Int,pullDown:Bool)//id:请求页面数据的id pullDown:判断是下拉刷新还是切换页面
    }
    enum Mutation {
        case setBranch(BranchDataModel,Int)
    }
    struct State {
        var branchModel: BranchDataModel?
        var sections: [BranchViewSection]?
    }
    let initialState: State
    let homeService: HomeServiceType
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus>
    var idx: [Int:BranchDataModel] = [:]
    init(homeService:HomeServiceType) {
        defer { _ = self.state }
        self.homeService = homeService
        self.initialState = State()
        self.refreshStatus = BehaviorRelay<BilibiliRefreshStatus>(value: .none)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .refresh(let id,let pullDown):
            
            if pullDown { //手动下拉刷新
                return homeService.BranchData(id: id).asObservable().map{.setBranch($0,id)}
            }else{ //切换页面
                if let branchModel = idx[id] {
                    return Observable.just(.setBranch(branchModel,id))
                }else{
                    return homeService.BranchData(id: id).asObservable().map{.setBranch($0,id)}
                }
            }
        }
    }
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setBranch(let branchModel,let id):
            self.refreshStatus.accept(.endHeaderRefresh)
            idx.updateValue(branchModel, forKey: id)
            state.sections = getSections(branchModel: branchModel)
            state.branchModel = branchModel
        }
        return state
    }
    //MARK - Private
    private func getSections(branchModel:BranchDataModel) -> [BranchViewSection] {
        
        var sections: [BranchViewSection] = []
        for item in branchModel.item {
            let sectionReactor = BranchSectionReactor(item: item)
            sections.append(BranchViewSection(header: item, items: sectionReactor.currentState.sectionItems.map{BranchViewSectionItem.branch($0)}))
        }
        return sections
    }
}
