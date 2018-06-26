//
//  NetAnimationView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/15.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

enum AnimationType {
    case loading
    case failure
}

final class NetAnimationView: UIView {

    fileprivate var type : AnimationType
    
    fileprivate let imageView = UIImageView().then{
        $0.contentMode = UIViewContentMode.scaleToFill
    }
    
    fileprivate let textLabel = UILabel().then{
        $0.textColor = .db_darkGray
        $0.font = Font.SysFont.sys_15
        $0.textAlignment = .center
    }
    
    init(animationType:AnimationType) {
        
        self.type = animationType
        
        super.init(frame: .zero)

        self.isHidden = true
        
        addSubview(imageView)
        addSubview(textLabel)
        
        configureSubView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func configureSubView() {
        
        if type == .loading {
           textLabel.text = "正在努力加载数据中..."
           imageView.image = UIImage(named: "animation_loading_loading_1")
           imageView.animationImages = [UIImage(named: "animation_loading_loading_1")!,UIImage(named: "animation_loading_loading_2")!]
           imageView.animationDuration = 0.5
           imageView.animationRepeatCount = 0
        }
        
        if type == .failure {
           textLabel.text = "似乎与互联网已经断开连接"
           imageView.image = UIImage(named: "animation_loading_error_4")
           imageView.animationImages = [UIImage(named: "animation_loading_error_1")!,
                                        UIImage(named: "animation_loading_error_2")!,
                                        UIImage(named: "animation_loading_error_3")!,
                                        UIImage(named: "animation_loading_error_4")!]
           imageView.animationDuration = 2.0
           imageView.animationRepeatCount = 1
        }
        
    }
    
    func startAnimation(animationType:AnimationType) {
        
        self.isHidden = false
       
        imageView.startAnimating()
        
    }
    
    func stopAnimation(animationType:AnimationType = .loading) {
        self.isHidden = true
        
        imageView.stopAnimating()
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(180)
        }
        
        textLabel.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(imageView.snp.bottom)
            make.height.equalTo(20)
        }
    }
    
    
    
    
}
