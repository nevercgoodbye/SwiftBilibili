//
//  PopOverViewCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/2.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

class PopOverViewCell: UITableViewCell {
    
    @IBOutlet weak var actionImageView: UIImageView!
    
    @IBOutlet weak var actionTitleLabel: UILabel!
    
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var imageViewWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLeftConstraint: NSLayoutConstraint!
    var titleLeft: CGFloat = 0
    
    override func awakeFromNib() {
        super.awakeFromNib()
    
        titleLeft = titleLeftConstraint.constant
    
        backgroundColor = .white
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor(white: 0.9, alpha: 1.0)
        selectedBackgroundView = backgroundView
        
    }

    func reloadData(title:String?,image:UIImage?) {
        
        actionTitleLabel.text = title
        actionImageView.image = image
        
        titleLeftConstraint.constant = image == nil ? 20 : titleLeft
        
        actionTitleLabel.textAlignment = image == nil ? .center : .left
        
        setNeedsLayout()
    }

    
    
}
