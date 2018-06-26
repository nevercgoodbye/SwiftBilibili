//
//  DramaReviewCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import ReactorKit

final class DramaReviewCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var avaterURL: URL?
        var title: String
        var content: String
        var uname: String
        var likes: String
        var reply: String
        var isShowBottomLine: Bool
    }
    
    let initialState: State
    
    let review: DramaReviewModel
    
    init(review: DramaReviewModel) {
        
        self.review = review
        
        let coverURL = URL(string: review.media.cover)
        let avaterURL = URL(string: review.author.avatar)
        
        self.initialState = State(coverURL: coverURL,
                                  avaterURL: avaterURL,
                                  title: review.title,
                                  content: review.content,
                                  uname: review.author.uname,
                                  likes: review.likes,
                                  reply: review.reply,
                                  isShowBottomLine: review.isShowBottomLine)
        _ = self.state
    }
    
    
}
