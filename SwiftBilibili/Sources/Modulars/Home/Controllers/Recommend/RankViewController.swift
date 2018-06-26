//
//  RankViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/10.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class RankViewController: BaseTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.isEmptyDisplay = false
        self.hideAnimationView(self.tableView)
        
    }

}
