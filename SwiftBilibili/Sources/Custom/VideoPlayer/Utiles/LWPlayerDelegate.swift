//
//  LWPlayerDelegate.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

public protocol LWPlayerDelegate : class {

   func player(_ player: LWPlayer ,playerStateDidChange state: LWPlayerState)
   
   func player(_ player: LWPlayer ,playerDisplayModeDidChange displayMode: LWPlayerDisplayMode)
    
   func player(_ player: LWPlayer ,loadedTimeDidChange bufferDuration: TimeInterval, totalDuration: TimeInterval)
    
   func player(_ player: LWPlayer ,playedTimeDidChange currentTime: TimeInterval, totalDuration: TimeInterval)
    
   func player(_ player: LWPlayer ,showLoading: Bool)
}

public protocol LWPlayerHorizontalPan: class {
    func player(_ player: LWPlayer ,progressWillChange value: TimeInterval)
    func player(_ player: LWPlayer ,progressChanging value: TimeInterval)
    func player(_ player: LWPlayer ,progressDidChange value: TimeInterval)
}

public protocol LWPlayerGestureRecognizer: class {
    func player(_ player: LWPlayer ,singleTapGestureTapped singleTap: UITapGestureRecognizer)
    func player(_ player: LWPlayer ,doubleTapGestureTapped doubleTap: UITapGestureRecognizer)
}


public protocol LWPlayerCustomAction:class {
    weak var player: LWPlayer? { get set }
    var autoHidedControlViews: [UIView] { get set }
    
    func playPauseButtonPressed(_ sender: Any)
    func fullEmbeddedScreenButtonPressed(_ sender: Any)
    func audioSubtitleCCButtonPressed(_ sender: Any)
    func backButtonPressed(_ sender: Any)
}

public protocol LWPlayerCustom: LWPlayerDelegate,LWPlayerCustomAction,LWPlayerHorizontalPan,LWPlayerGestureRecognizer {
}

