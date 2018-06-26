//
//  TogetherViewSectionReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SectionReactor
import RxSwift

final class TogetherViewSectionReactor: SectionReactor {
    
    enum SectionItem {
        case av(TogetherAvCellReactor)
        case ad(TogetherAdCellReactor)
    }
    
    enum Action {}

    enum Mutation {}
    
    struct State: SectionReactorState {
        var tagetherModels: [RecommendTogetherModel]
        var sectionItems: [SectionItem]
    }
    
    let initialState: State
    
    init(togetherModels:[RecommendTogetherModel]) {
        
        defer { _ = self.state }
        
        var sectionItems: [SectionItem] = []
        
        for togetherModel in togetherModels {
            switch togetherModel.goto{
            case .av:
                sectionItems.append(.av(TogetherAvCellReactor(recommend: togetherModel)))
            case .ad:
                sectionItems.append(.ad(TogetherAdCellReactor(recommend: togetherModel)))
            default:break
            }
        }
        self.initialState = State(tagetherModels: togetherModels, sectionItems: sectionItems)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
    
}
