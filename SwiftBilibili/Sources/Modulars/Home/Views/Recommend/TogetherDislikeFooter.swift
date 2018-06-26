//
//  TogetherDislikeFooter.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/3.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxSwift

final class TogetherDislikeFooter: UIView {

    @IBOutlet weak var upNameButton: UIButton!
    
    @IBOutlet weak var zoneNameButton: UIButton!
    
    @IBOutlet weak var remarkNameButton: UIButton!

    @IBOutlet weak var defaultNameButton: UIButton!
    var dislikeTapSubject = PublishSubject<TogetherDislikeModel>()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        upNameButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            
            let reason_name = self.upNameButton.title(for: .normal)!
            self.dislikeTapSubject.onNext(TogetherDislikeModel(reason_name: reason_name, reason_type: .up))
            
        }).disposed(by: rx.disposeBag)
        
        zoneNameButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            let reason_name = self.zoneNameButton.title(for: .normal)!
            self.dislikeTapSubject.onNext(TogetherDislikeModel(reason_name: reason_name, reason_type: .zone))
        }).disposed(by: rx.disposeBag)
        
        remarkNameButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            let reason_name = self.remarkNameButton.title(for: .normal)!
            self.dislikeTapSubject.onNext(TogetherDislikeModel(reason_name: reason_name, reason_type: .remark))
        }).disposed(by: rx.disposeBag)
        
        defaultNameButton.rx.tap.subscribe(onNext: {[unowned self] (_) in
            let reason_name = self.defaultNameButton.title(for: .normal)!
            self.dislikeTapSubject.onNext(TogetherDislikeModel(reason_name: reason_name, reason_type: .noInterest))
        }).disposed(by: rx.disposeBag)
        
    }
    
    func reloadData(upName:String?,zoneName:String?,remarkName:String?) {
        upNameButton.setTitle(upName ?? "", for: .normal)
        zoneNameButton.setTitle(zoneName ?? "", for: .normal)
        remarkNameButton.setTitle(remarkName ?? "", for: .normal)
    }
    
    
}
