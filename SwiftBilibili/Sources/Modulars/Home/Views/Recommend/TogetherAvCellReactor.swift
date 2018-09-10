//
//  TogetherAvCellReactor.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//
import ReactorKit

final class TogetherAvCellReactor: Reactor {

    typealias Action = NoAction
    
    struct State {
        var coverURL: URL?
        var title: String?
        var playTimes: String?
        var danmakus: String?
        var duration: String?
        var desc: String?
        var rcmdColor: UIColor?
        var rcmdTitle: String?
        var hiddenDislike: Bool
    }
    
    let initialState: State
    
    let together: RecommendTogetherModel
    
    init(together: RecommendTogetherModel) {
        
        self.together = together
        
        let coverURL = URL(string: together.cover ?? "")
        let rcmdColor = together.rcmd_reason?.bg_color.color
        let rcmdTitle = together.rcmd_reason?.content
        let danmakus = together.danmaku
        
        var desc: String = ""
        
        if let categoryName = together.tname {
            desc = "\(categoryName)"
        }
        if let childName = together.tag?.tag_name {
            desc += " · \(childName)"
        }
        
        self.initialState = State(coverURL: coverURL,
                                  title: together.title,
                                  playTimes: together.play,
                                  danmakus: danmakus,
                                  duration: together.duration,
                                  desc: desc,
                                  rcmdColor: rcmdColor,
                                  rcmdTitle: rcmdTitle,
                                  hiddenDislike:false)
        _ = self.state
    }
    
    init(branch:BranchAvModel) {
        
        self.together = RecommendTogetherModel(isShowTip: false)
        
        let coverURL = URL(string: branch.cover ?? "")
        
        self.initialState = State(coverURL: coverURL,
                                  title: branch.title,
                                  playTimes: branch.play,
                                  danmakus: branch.danmaku,
                                  duration: branch.duration,
                                  desc: branch.tname,
                                  rcmdColor: nil,
                                  rcmdTitle: nil,
                                  hiddenDislike:true)
        _ = self.state
    }
}
