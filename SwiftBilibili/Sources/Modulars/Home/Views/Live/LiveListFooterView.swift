//
//  LiveListFooterView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/27.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit


final class LiveListFooterView: UICollectionReusableView {
    
    @IBOutlet weak var checkMoreButton: BilibiliButton!
    @IBOutlet weak var allLiveButton: UIButton!
    @IBOutlet weak var allLiveView: UIView!
    
    private var headerModel: LiveHeaderModel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        checkMoreButton.setTitleColor(.db_pink, for: .normal)
        checkMoreButton.setImage(Image.Home.rightArrow?.with(color: .db_pink), for: .normal)
        
        allLiveView.backgroundColor = UIColor.db_gray
        
        allLiveButton.setTitleColor(UIColor.db_darkGray, for: .normal)
        allLiveButton.borderColor = UIColor.db_darkGray
        allLiveButton.borderWidth = 0.5
        allLiveButton.cornerRadius = 3
        
        checkMoreButton.imagePosition = .right
        checkMoreButton.space = 0
        
        checkMoreButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            
            BilibiliRouter.open(self.headerModel?.link ?? "")
        
        }).disposed(by: rx.disposeBag)
        
        allLiveButton.rx.tap.subscribe(onNext: { (_) in
            
            BilibiliRouter.push(.live_all)
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    func reloadData(headerModel:LiveHeaderModel?){
        
        self.headerModel = headerModel
        
        guard let headerModel = headerModel else { return }
        
        if headerModel.count != nil {
            checkMoreButton.setTitle("更多\(headerModel.count!)个推荐直播", for: .normal)
        }else{
            checkMoreButton.setTitle("查看更多", for: .normal)
        }
    }
}
