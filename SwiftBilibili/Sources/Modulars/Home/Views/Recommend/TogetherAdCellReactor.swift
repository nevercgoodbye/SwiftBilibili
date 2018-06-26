//
//  TogetherAdCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class TogetherAdCellReactor: Reactor {
    
    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String?
        var des: String?
        var cellSize: CGSize
    }
    
    let initialState: State
    
    let together: RecommendTogetherModel
    
    init(together: RecommendTogetherModel) {
        
        self.together = together
        
        let coverURL = URL(string: together.cover ?? "")
        
        var cellSize: CGSize = .zero
        
        if together.goto == .ad {
            cellSize = CGSize(width: kScreenWidth-2*kCollectionItemPadding, height: kAdItemHeight)
        }else{
            cellSize = CGSize(width: (kScreenWidth-3*kCollectionItemPadding)/2, height: kNormalItemHeight)
        }
        
        self.initialState = State(coverURL: coverURL,
                                  title: together.title,
                                  des: together.desc,
                                  cellSize:cellSize)
        _ = self.state
    }
}
