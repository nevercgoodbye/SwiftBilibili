//
//  TogetherBannerCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit
import RxSwift

final class TogetherBannerCellReactor: Reactor {
    typealias Action = NoAction
    
    struct State {
        var banners: [BilibiliBannerModel]
        var cellSize: CGSize
    }
    
    let initialState: State
    
    init(together: RecommendTogetherModel) {
        
        let banners = together.banner_item!.map{BilibiliBannerModel(imageUrl: $0.image, title: $0.title, link: $0.uri, isAd: $0.is_ad ?? false)}

        self.initialState = State(banners: banners,cellSize:CGSize(width: kScreenWidth-2*kCollectionItemPadding, height: kBannerHeight))
        _ = self.state
    }
}
