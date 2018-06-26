//
//  LivePartitionViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/23.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LivePartitionViewController: BaseViewController {

    private var partitionType: LivePartitionType
    private var name: String
    
    init(partitionType:LivePartitionType,name:String) {
        
        self.partitionType = partitionType
        self.name = name
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = name
    }


}
