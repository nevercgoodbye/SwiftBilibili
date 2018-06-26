//
//  DramaSectionReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SectionReactor
import RxSwift

final class DramaSectionReactor: SectionReactor {

    enum SectionItem {
        case review(DramaReviewCellReactor)
        case edit(DramaEditCellReactor)
        case vertical(DramaVerticalCellReactor)
    }
    
    enum Action {}
    
    enum Mutation {}
    
    struct State: SectionReactorState {
        var sectionItems: [SectionItem]
    }
    
    let initialState: State
    
    init(followModels:[DramaFollowModel]? = nil,
         cnModel:DramaCnModel? = nil,
         reviewModels:[DramaReviewModel]? = nil,
         footModels:[DramaFootModel]? = nil) {
        
        defer { _ = self.state }
        
        var sectionItems: [SectionItem] = []
        
        if let followModels = followModels {
            for follow in followModels {
               sectionItems.append(.vertical(DramaVerticalCellReactor(follow: follow)))
            }
        }
        
        if let cnModel = cnModel {
            for recommend in cnModel.recommend {
                sectionItems.append(.vertical(DramaVerticalCellReactor(recommend: recommend)))
            }
            
            for foot in cnModel.foot {
                sectionItems.append(.edit(DramaEditCellReactor(foot: foot)))
            }
        }
        
        if let reviewModels = reviewModels {
            
            for review in reviewModels {
                sectionItems.append(.review(DramaReviewCellReactor(review: review)))
            }
        }
        
        if let footModels = footModels {
            for foot in footModels {
                sectionItems.append(.edit(DramaEditCellReactor(foot: foot)))
            }
        }

        self.initialState = State(sectionItems: sectionItems)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        
        return .empty()
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        return state
    }
}
