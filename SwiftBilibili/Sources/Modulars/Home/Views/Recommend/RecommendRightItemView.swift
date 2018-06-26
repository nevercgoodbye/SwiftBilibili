//
//  RecommendRightItemView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class RecommendRightItemView: UIView,NibLoadable {

    @IBOutlet weak var rankButton: UIButton!
    
    @IBAction func rankClick(_ sender: UIButton) {
        
        BilibiliRouter.push(BilibiliPushType.recommend_rank, context: ["isFromRcmd":true])
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        rankButton.setTitle("排行榜", for: .normal)
        rankButton.setTitleColor(.db_darkGray, for: .normal)
        rankButton.setImage(Image.Home.rank?.withRenderingMode(.alwaysOriginal), for: .normal)
        rankButton.titleLabel?.font = Font.SysFont.sys_12
    }
}
