//
//  TogetherDislikeMaskView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/4.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxSwift

final class TogetherDislikeMaskView: UIView,NibLoadable {
    
    var recallSubject = PublishSubject<UIButton>()
    
    @IBOutlet weak var reasonLabel: UILabel!

    @IBOutlet weak var recallButton: UIButton!
    
    @IBAction func recall(_ sender: UIButton) {
        recallSubject.onNext(sender)
    }
}
