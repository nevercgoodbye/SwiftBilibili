//
//  BranchEntranceCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/9/7.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReactorKit

final class BranchEntranceCell: BaseCollectionViewCell,View {
    
    let scrollView = UIScrollView().then{
        $0.showsHorizontalScrollIndicator = false
        
    }
    
    override func initialize() {
        
        self.backgroundColor = UIColor.clear
        
        addSubview(scrollView)
    }
    
    func bind(reactor: BranchEntranceCellReactor) {
        
        reactor.state.map{$0.items}.subscribe(onNext: {[unowned self] (items) in
            
            self.configItems(items: items)
    
        }).disposed(by: disposeBag)
    }
    
    private func configItems(items:[BranchAvModel]) {
        
        let buttonSize = CGSize(width: 40, height: self.height)
        let margin: CGFloat = 30
        
        for i in 0..<items.count {
            let model = items[i]
            let x = i == 0 ? margin/3 : CGFloat(i) * (margin + buttonSize.width) + margin/3
            let button = VerticalButton(frame: CGRect(x: x, y: 0, width: buttonSize.width, height: buttonSize.height))
            button.setImage(imageUrl: model.cover ?? "",cornerRadius: 4)
            button.setTitle(title: model.title ?? "", textColor: UIColor.db_darkGray)
            scrollView.addSubview(button)
        }
        
        if let lastSubView = scrollView.subviews.last {
           scrollView.contentSize = CGSize(width: lastSubView.frame.maxX + margin/3, height: 0)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollView.snp.makeConstraints { (make) in
           make.edges.equalToSuperview()
        }
        
    }
    
}
