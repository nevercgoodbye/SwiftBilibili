//
//  LivePartitionViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/23.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class LivePartitionViewController: BaseViewController {

    private var parent_area_id: String
    private var parent_area_name: String
    private var area_id: String
    private var area_name: String
    
    init(parent_area_id:String,parent_area_name: String,area_id: String,area_name: String) {
        
        self.parent_area_id = parent_area_id
        self.parent_area_name = parent_area_name
        self.area_id = area_id
        self.area_name = area_name
        
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

        self.title = self.parent_area_name
    }


}
