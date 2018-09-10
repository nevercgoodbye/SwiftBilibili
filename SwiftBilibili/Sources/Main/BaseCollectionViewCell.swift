//
//  BaseCollectionViewCell.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/17.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxSwift


class BaseCollectionViewCell: UICollectionViewCell {
    
    var disposeBag = DisposeBag()
    
    // MARK: Initializing
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.db_white
        
        initialize()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(frame: .zero)
    }
    
    func initialize() {
        
    }
}
