//
//  TogetherSectionReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SectionReactor
import RxSwift

final class TogetherSectionReactor: SectionReactor {
    
    enum SectionItem {
        case av(TogetherAvCellReactor)
        case ad(TogetherAdCellReactor)
        case live(TogetherLiveCellReactor)
        case article(TogetherArticleCellReactor)
        case banner(TogetherBannerCellReactor)
        case special(TogetherSpecialCellReactor)
        case tip
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
            if togetherModel.isShowTip {
               sectionItems.append(.tip)
            }else{
                switch togetherModel.goto{
                case .av:
                    sectionItems.append(.av(TogetherAvCellReactor(together: togetherModel)))
                case .ad,.ad_s:
                    sectionItems.append(.ad(TogetherAdCellReactor(together: togetherModel)))
                case .live:
                    sectionItems.append(.live(TogetherLiveCellReactor(together: togetherModel)))
                case .article:
                    sectionItems.append(.article(TogetherArticleCellReactor(together: togetherModel)))
                case .banner:
                    sectionItems.append(.banner(TogetherBannerCellReactor(together: togetherModel)))
                case .special_s:
                    sectionItems.append(.special(TogetherSpecialCellReactor(together: togetherModel)))
                default:break
            }
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
