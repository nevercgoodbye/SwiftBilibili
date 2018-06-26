//
//  LiveRoomViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/27.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LiveRoomViewController: BaseViewController {

    let testView = UIView().then{
        $0.backgroundColor = UIColor.black
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.addSubview(testView)
        
        testView.frame = CGRect(x: 0, y: 0, width: kScreenWidth, height: 200)
        
        LWPlayerManager.sharedInstance.playEmbeddedVideo(url: Bundle.main.url(forResource: "blackhole", withExtension: "mp4")!, embeddedContentView: testView)
        
    }
    
    override func setupConstraints() {
        
//        testView.snp.makeConstraints { (make) in
//            make.left.top.right.equalToSuperview()
//            make.height.equalTo(200)
//        }
    }
    

}
