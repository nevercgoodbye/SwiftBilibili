//
//  LiveListFooterView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/27.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LiveListFooterView: UICollectionReusableView {

    var partitionType: LivePartitionType?
    
    @IBOutlet weak var switchButton: BilibiliButton!
    @IBOutlet weak var allLiveButton: UIButton!
    @IBOutlet weak var allLiveView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        switchButton.setTitleColor(.db_pink, for: .normal)
        
        allLiveButton.setTitleColor(UIColor.db_darkGray, for: .normal)
        
        switchButton.imagePosition = .right
        switchButton.space = 5
        switchButton.imageSize = CGSize(width: 10, height: 10)
        
        NotificationCenter.default.rx.notification(custom: .stopRotate)
            .subscribe(onNext: {[unowned self] (_) in
            
             guard let refreshImageView = self.switchButton.imageView else { return }
             refreshImageView.layer.removeAllAnimations()
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    
    @IBAction func startSwitch(_ sender: UIButton) {
        
        guard let refreshImageView = switchButton.imageView,
              let partitionType = partitionType
        else { return }
        
        refreshImageView.layer.removeAllAnimations()
        
        let rotaAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotaAnimation.toValue = CGFloat.pi * 4
        rotaAnimation.repeatCount = 10
        rotaAnimation.duration = CFTimeInterval(kLivePartitionRefreshRotationTime)
        refreshImageView.layer.add(rotaAnimation, forKey: "rotaanimation")
        
        if partitionType == .recommend {
            LiveTotalModel.event.onNext(.refreshRecommendPartition)
        }else{
            LiveTotalModel.event.onNext(.refreshCommonPartition(partitionType))
        }
    }
}
