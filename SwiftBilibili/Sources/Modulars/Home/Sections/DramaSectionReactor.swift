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
import Dollar


final class DramaSectionReactor: SectionReactor {

    enum SectionItem {
        case vertical(DramaVerticalCellReactor)
        case edit(DramaEditCellReactor)
    }
    
    enum Action {}
    
    enum Mutation {}
    
    struct State: SectionReactorState {
        var sectionItems: [SectionItem]
    }
    
    let initialState: State
    
    init(moduleModel:DramaModuleModel) {
        
        defer { _ = self.state }
        
        var sectionItems: [SectionItem] = []
        
        let resultItems = Dollar.chunk(moduleModel.items, size: 3)[0]
        
        if let headers = moduleModel.headers,!headers.isEmpty {
            for i in 0..<resultItems.count {
                var model = moduleModel.items[i]
                model.position = DramaVerticalPosition(rawValue: i)!
                sectionItems.append(.vertical(DramaVerticalCellReactor(recommend: model)))
            }
        }else{
             sectionItems = resultItems.map{.edit(DramaEditCellReactor(foot: $0))}
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
