//
//  LiveListPartitionHeaderView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LiveListPartitionHeaderView: UIView,NibLoadable {

    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var changeButton: BilibiliButton!
    @IBOutlet weak var timeRangeLabel: UILabel!
    @IBOutlet weak var imageWidthConstraint: NSLayoutConstraint!
    
    private var liveHeaderModel: LiveHeaderModel?
    private var dramaHeaderModel: DramaHeaderModel?
    private var branchHeaderModel: BranchItemModel?
    
    private let rankHourId = 4
    
    override func awakeFromNib() {
        super.awakeFromNib()

        changeButton.imagePosition = .right

        changeButton.titleLabel?.font = Font.SysFont.sys_13
        
        changeButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
    
            if let headerModel = self.liveHeaderModel {
                if headerModel.id == self.rankHourId {//小时榜
                    BilibiliRouter.push(headerModel.link)
                }else{
                    guard let refreshImageView = self.changeButton.imageView else { return }
                    refreshImageView.layer.removeAllAnimations()
                    let rotaAnimation = CABasicAnimation(keyPath: "transform.rotation")
                    rotaAnimation.toValue = CGFloat.pi * 3
                    rotaAnimation.repeatCount = 10
                    rotaAnimation.duration = CFTimeInterval(kLivePartitionRefreshRotationTime)
                    refreshImageView.layer.add(rotaAnimation, forKey: "rotaanimation")
                    LiveTotalModel.event.onNext(.exchange(moduleId: headerModel.id))
                }
            }else if let headerModel = self.dramaHeaderModel {
//                switch headerModel.type {
//                case .mine:
//                    let context: [AnyHashable: Any] = ["isRcmd":false]
//                    BilibiliRouter.push(.drama_recommend,context:context)
//                default:
//                    BilibiliToaster.show(headerModel.type.title)
//                }
            }
        }).disposed(by: rx.disposeBag)
        
        NotificationCenter.default.rx.notification(custom: .stopRotate)
            .subscribe(onNext: {[unowned self] (_) in
                 guard let refreshImageView = self.changeButton.imageView else { return }
                 refreshImageView.layer.removeAllAnimations()
            })
            .disposed(by: rx.disposeBag)
    }
    
    func reloadLiveData(headerModel:LiveHeaderModel) {
        
        self.liveHeaderModel = headerModel
        
        iconImageView.setImage(with: URL(string:headerModel.pic))
        
        titleLabel.text = headerModel.title

        timeRangeLabel.text = headerModel.sub_title
        
        if changeButton.imageSize == .zero {
            changeButton.imageSize = CGSize(width: 15, height: 15)
            changeButton.space = 5
        }
    
        if headerModel.id == self.rankHourId {
            changeButton.setTitle("查看更多", for: .normal)
            changeButton.setTitleColor(UIColor.db_pink, for: .normal)
            changeButton.setImage(Image.Home.rightArrow?.with(color: .db_pink), for: .normal)
        }else{
            changeButton.setTitle("换一换", for: .normal)
            changeButton.setTitleColor(UIColor.db_darkGray, for: .normal)
            changeButton.setImage(Image.Home.refresh, for: .normal)
        }
    }
    
    func reloadDarmaData(headerModel:DramaHeaderModel) {
        
        self.dramaHeaderModel = headerModel
        
        changeButton.isHidden = headerModel.title == nil
        changeButton.setTitle(headerModel.title ?? "", for: .normal)
        
        if changeButton.imageSize == .zero {
            changeButton.setTitleColor(UIColor.db_darkGray, for: .normal)
            changeButton.setImage(Image.Home.rightArrow?.with(color: .db_darkGray), for: .normal)
            changeButton.imageSize = CGSize(width: 15, height: 15)
            changeButton.space = 0
        }
        
        titleLabel.text = headerModel.name
        
        self.imageWidthConstraint.constant = 0
        
        self.layoutIfNeeded()
    }
}
