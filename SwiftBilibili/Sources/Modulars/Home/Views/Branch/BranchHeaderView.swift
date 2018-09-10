//
//  BranchHeaderView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/7/14.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class BranchHeaderView: UICollectionReusableView {

    let partitionHeaderView = BranchPartitionView()
    
    private var headerModel:BranchItemModel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(partitionHeaderView)
        
        self.backgroundColor = UIColor.clear
        
        self.rx.tapGesture().subscribe(onNext: {[unowned self] (_) in
            
            guard let headerModel = self.headerModel
                else { return  }
            
            if headerModel.goto != .tag_rcmd { return  }
            
            BilibiliToaster.show(headerModel.title ?? "")
            
        }).disposed(by: rx.disposeBag)

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(headerModel:BranchItemModel?) {
        
        self.headerModel = headerModel
        
        guard let headerModel = headerModel else { return }
        
        partitionHeaderView.reloadBranchData(headerModel: headerModel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        partitionHeaderView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
    
}
