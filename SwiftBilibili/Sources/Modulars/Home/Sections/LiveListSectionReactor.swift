//
//  LiveListSectionReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import SectionReactor
import RxSwift

final class LiveListSectionReactor: SectionReactor {

    enum SectionItem {
        case av(LiveAvCellReactor)
        case banner(LiveBannerCellReactor)
        case beauty(LiveBeautyCellReactor)
    }
    
    enum Action {}
    
    enum Mutation {}
    
    struct State: SectionReactorState {
        var sectionItems: [SectionItem]
    }
    
    let initialState: State

    init(rcmdAvModels: [LiveRecommendAvModel]? = nil,
         beautyAvModels: [LivePartitionAvModel]? = nil,
         partitionAvModels: [LivePartitionAvModel]? = nil,
         rcmdBannerModel: LiveRecommendBannerModel? = nil) {
        
        defer { _ = self.state }
        var sectionItems: [SectionItem] = []
        
        if let rcmdAvModels = rcmdAvModels,let rcmdBannerModel = rcmdBannerModel {
            sectionItems = rcmdAvModels.map{.av(LiveAvCellReactor(live: LivePartitionAvModel(recommendAvModel: $0)))}
            sectionItems.insert(.banner(LiveBannerCellReactor(banner: rcmdBannerModel)), at: sectionItems.count/2)
        }else if let rcmdAvModels = rcmdAvModels {
            sectionItems = rcmdAvModels.map{.av(LiveAvCellReactor(live: LivePartitionAvModel(recommendAvModel: $0)))}
        }else if let rcmdBannerModel = rcmdBannerModel {
            sectionItems = [.banner(LiveBannerCellReactor(banner: rcmdBannerModel))]
        }
    
        if let partitionAvModels = partitionAvModels {
            sectionItems = partitionAvModels.map{.av(LiveAvCellReactor(live: $0))}
        }
        
        if let beautyAvModels = beautyAvModels {
            sectionItems = beautyAvModels.map{.beauty(LiveBeautyCellReactor(live: $0))}
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
