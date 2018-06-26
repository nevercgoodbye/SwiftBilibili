//
//  LWPlayerManager.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/2.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

class LWPlayerManager {

    var player: LWPlayer?
    var embeddedContentView: UIView?
    
    static let sharedInstance = LWPlayerManager()
    
    func playEmbeddedVideo(url: URL?, embeddedContentView contentView: UIView? = nil) {
        
        self.player = LWPlayer()
        self.embeddedContentView = contentView
        self.player!.playWithURL(url, embeddedContentView: embeddedContentView)
    }
    
}
