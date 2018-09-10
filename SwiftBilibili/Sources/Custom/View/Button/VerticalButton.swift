//
//  VerticalButton.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/9/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class VerticalButton: UIView {

    let imageView = UIImageView().then{
        $0.contentMode = UIViewContentMode.scaleAspectFill
        $0.clipsToBounds = true
    }
    
    let titleLabel = UILabel().then{
        $0.font = Font.SysFont.sys_12
        $0.textColor = UIColor.db_lightBlack
        $0.textAlignment = .center
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configSubViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(imageUrl:String,cornerRadius: CGFloat = 0) {
        
        imageView.setImage(with: URL(string: imageUrl))
        if cornerRadius > 0 {
            imageView.cornerRadius = cornerRadius
        }
    }
    
    func setTitle(title:String,font:UIFont? = nil,textColor:UIColor? = nil) {
        
        titleLabel.text = title
        if let font = font {
            titleLabel.font = font
        }
        if let textColor = textColor {
            titleLabel.textColor = textColor
        }
    }

    private func configSubViews() {
        addSubview(imageView)
        addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
        }
    
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.size.equalTo(30)
            make.centerX.equalToSuperview()
            
        }
    }
}
