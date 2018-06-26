//
//  RankViewReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class RankViewReactor: NSObject {

    enum Action {
        case refresh
    }
    
    enum Mutation {
        case setTogethers([RecommendTogetherModel])
    }
    
    struct State {
        var isLoading: Bool = false
        var moveCount: Int?
        var togetherModels: [RecommendTogetherModel] = []
        var sections: [TogetherViewSection]?
    }
    //let initialState: State
    
    
    
    
}
