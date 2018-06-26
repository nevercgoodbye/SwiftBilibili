//
//  GesConflictCollectionView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/4.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class GesConflictCollectionView: UICollectionView,UIGestureRecognizerDelegate {

    var allowOtherGes: Bool = false
    
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        return allowOtherGes
        
    }

}
