//
//  LWPlayerFullScreenViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/29.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

class LWPlayerFullScreenViewController: UIViewController {

    weak var player: LWPlayer!
    
    var preferredlandscapeForPresentation = UIInterfaceOrientation.landscapeLeft
    
    var currentOrientation = UIDevice.current.orientation
    
    private var statusBarHiddenAnimated = true
    
    lazy var statusbarBackgroundView : UIView = {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.width, height: UIApplication.shared.statusBarFrame.height))
        view.backgroundColor = player.fullScreenStatusbarBackgroundColor
        view.autoresizingMask = [ .flexibleWidth,.flexibleLeftMargin,.flexibleRightMargin,.flexibleBottomMargin]
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        NotificationCenter.default.addObserver(self, selector: <#T##Selector#>, name: <#T##NSNotification.Name?#>, object: <#T##Any?#>)
        
        
        
    }
    
    @objc func playerControlsHiddenDidChange(_ notifiaction: Notification) {
//        self.statusBarHiddenAnimated = notifiaction.userInfo?[Notification.Key.EZPlayerControlsHiddenDidChangeByAnimatedKey] as? Bool ?? true
//        self.setNeedsStatusBarAppearanceUpdate()
//        if #available(iOS 11.0, *) {
//            self.setNeedsUpdateOfHomeIndicatorAutoHidden()
//        }
    }
    
    
}
