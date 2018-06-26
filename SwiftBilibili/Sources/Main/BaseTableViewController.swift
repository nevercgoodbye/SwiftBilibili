//
//  BaseTableViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxSwift
import EmptyKit

class BaseTableViewController: BaseViewController,Refreshable {
    
    var isEmptyDisplay: Bool = true
    
    let tableView: UITableView = UITableView().then{
        $0.backgroundColor = .db_gray
        $0.showsVerticalScrollIndicator = false
        $0.tableFooterView = UIView()
    }
    
    override func setupConstraints() {
        tableView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.ept.dataSource = self
        tableView.ept.delegate = self
        
        view.addSubview(tableView)
        
        showLoadAnimation()
        
        registerNetErrorNotification()
        
    }
    
    //MARK: Public Method
    func startRefresh() {
        
        self.tableView.setContentOffset(.zero, animated: true)
        DispatchQueue.delay(time: 0.3, action: {
            self.tableView.es.startPullToRefresh()
        })
    }
    
    func registerNetErrorNotification() {
        
        NotificationCenter.default.rx.notification(custom: .netError)
            .subscribe(onNext: {[unowned self] (_) in
                
                self.stopRefresh()
                
                self.showNetErrorView()
                
            })
            .disposed(by: disposeBag)
    }
    
    
    func showNetErrorView() {
        
        if totalItems() > 0 { return }
        
        self.showAnimationView(self.tableView, animationType: .failure)
    }
    
    func showLoadAnimation() {
        self.showAnimationView(self.tableView)
    }
    
    func stopRefresh() {
        
        guard let isRefreshing = tableView.header?.isRefreshing else { return }
        
        if isRefreshing {
            tableView.es.stopPullToRefresh()
        }
    }
    
    //MARK: Private Method
    private func stopLoad() {
        
        guard let isLoading = tableView.footer?.isRefreshing else { return }
        
        if isLoading {
            tableView.es.stopLoadingMore()
        }
    }
}

//MARK: Notification
extension BaseTableViewController {
    
    func totalItems() -> Int {
        
        var totalItems: Int = 0
        
        let sectionCount = self.tableView.numberOfSections
        
        for i in 0 ..< sectionCount {
            
            let items = self.tableView.numberOfRows(inSection: i)
            
            totalItems += items
        }
        
        return totalItems
    }
}

extension BaseTableViewController:EmptyDelegate,EmptyDataSource {
    
    func customViewForEmpty(in view: UIView) -> UIView? {
        
        return EmptyView.loadFromNib()
    }
    
    func emptyShouldAllowScroll(in view: UIView) -> Bool {
        return true
    }
    
    func emptyShouldDisplay(in view: UIView) -> Bool {
        return isEmptyDisplay
    }
}
