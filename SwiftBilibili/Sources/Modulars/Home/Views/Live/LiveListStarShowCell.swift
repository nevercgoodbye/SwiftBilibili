//
//  LiveListStarShowCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/1.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LiveListStarShowCell: UICollectionViewCell {
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    @IBOutlet weak var anchorNameLabel: UILabel!
    
    @IBOutlet weak var concernNumLabel: UILabel!
    
    
    func reloadData(iconUrl:String,anchorName:String,concernNum:String) {
        
        iconImageView.setImage(with: URL(string:iconUrl), placeholder: UIImage.placeholderImage(bgSize: iconImageView.size))
        anchorNameLabel.text = anchorName
        concernNumLabel.text = "\(concernNum)人关注"
    }
    
}
