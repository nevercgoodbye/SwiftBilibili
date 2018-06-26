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
    
    @IBOutlet weak var moreLabel: UILabel!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        
        

    }
    
    func reloadData(iconUrl:String? = nil,iconImage:UIImage? = nil,partitionName:String,arrowName:NSAttributedString) {
        
        if let iconUrl = iconUrl {
           iconImageView.setImage(with: URL(string:iconUrl))
        }else if let iconImage = iconImage {
           iconImageView.image = iconImage
        }
        titleLabel.text = partitionName
        moreLabel.attributedText = arrowName

    }
    
}
