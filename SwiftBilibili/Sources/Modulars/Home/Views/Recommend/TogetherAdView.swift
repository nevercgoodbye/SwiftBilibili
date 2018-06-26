//
//  TogetherAdView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class TogetherAdView: UIView,NibLoadable {

    
    @IBOutlet weak var AdImageView: UIImageView!
    
    @IBOutlet weak var countDownButton: CountDownButton!
    
    @IBOutlet weak var titleButton: UIButton!
    
    private var uri: String = ""
    
    func startCountDown(adModel:ListRealmModel) {
        
        self.uri = adModel.uri
        
        UIApplication.shared.keyWindow?.addSubview(self)
        self.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        self.AdImageView.image = ImageManager.retrieveImage(key:adModel.thumb)
        self.titleButton.setTitle(adModel.uri_title, for: .normal)
        
        let title = NSMutableAttributedString(string:"跳过 \(adModel.duration)")
        title.setAttributes([.foregroundColor:UIColor.db_pink], range: NSRange(location: title.length - 1, length: 1))
        
        self.countDownButton.setAttributedTitle(title, for: .normal)
        self.countDownButton.countDownButtonClick { (sender) in
            self.removeFromSuperview()
        }
        self.countDownButton.startCountDownWithSecond(totalSecond: adModel.duration)
        self.countDownButton.countDownChanging { (_, second) -> NSAttributedString in
            let title = NSMutableAttributedString(string:"跳过 \(second)")
            title.setAttributes([.foregroundColor:UIColor.db_pink], range: NSRange(location: title.length - 1, length: 1))
            return title
        }
        self.countDownButton.countDownFinished { (_, _) -> NSAttributedString in
            self.removeFromSuperview()
            return NSAttributedString(string:"")
        }
        
    }
    
    @IBAction func titleButtonClick(_ sender: UIButton) {
        
        if !self.uri.isEmpty {
            self.removeFromSuperview()
            
            DispatchQueue.delay(time: 0.25) {[unowned self] in
                BilibiliRouter.push(self.uri)
            }
        }
        
        
    }
    
}
