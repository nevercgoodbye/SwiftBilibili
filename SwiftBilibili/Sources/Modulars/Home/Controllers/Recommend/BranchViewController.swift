//
//  BranchViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class BranchViewController: BaseCollectionViewController {

    private var requestId: Int
    
    init(requestId:Int) {
        self.requestId = requestId
        super.init()
        log.info(requestId)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.delay(time: 2) {
            self.hideAnimationView(self.collectionView)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
