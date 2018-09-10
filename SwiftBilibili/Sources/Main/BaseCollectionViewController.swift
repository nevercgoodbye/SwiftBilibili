//
//  BaseCollectionViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxSwift
import EmptyKit

class BaseCollectionViewController: BaseViewController,Refreshable {
    
    var isEmptyDisplay: Bool = true
    
    var allowListenScroll: Bool = false
    
    let collectionView: UICollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
        ).then{
            $0.backgroundColor = .db_gray
            $0.alwaysBounceVertical = true
            $0.showsVerticalScrollIndicator = false
    }
    
    override func setupConstraints() {
        collectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(0)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.ept.dataSource = self
        collectionView.ept.delegate = self
        
        view.addSubview(collectionView)
        
        showLoadAnimation()
        
        registerNetErrorNotification()
        
    }
    
    //MARK: Public Method
    func startRefresh() {
       
        self.collectionView.setContentOffset(.zero, animated: true)
        DispatchQueue.delay(time: 0.3, action: {
            self.collectionView.es.startPullToRefresh()
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
        
        self.showAnimationView(self.collectionView, animationType: .failure)
    }
    
    func showLoadAnimation() {
        self.showAnimationView(self.collectionView)
    }
    
    func hideLoadAnimation() {
        self.hideAnimationView(self.collectionView)
    }
    
    func stopRefresh() {
        
        guard let isRefreshing = collectionView.header?.isRefreshing else { return }
        
        if isRefreshing {
            collectionView.es.stopPullToRefresh()
        }
    }
    
    //MARK: Private Method
    private func stopLoad() {
        
        guard let isLoading = collectionView.footer?.isRefreshing else { return }
        
        if isLoading {
            collectionView.es.stopLoadingMore()
        }
    }
}

//MARK: Notification
extension BaseCollectionViewController {
    
   func totalItems() -> Int {
       
       var totalItems: Int = 0
        
       let sectionCount = self.collectionView.numberOfSections

       for i in 0 ..< sectionCount {
        
          let items = self.collectionView.numberOfItems(inSection: i)
        
          totalItems += items
       }
        
       return totalItems
    }
}

extension BaseCollectionViewController:EmptyDelegate,EmptyDataSource {
    
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

extension BaseCollectionViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard self.collectionView.enableDirection,
              let homeParentVc = UIViewController.topMost?.parent as? HomeParentViewController
        else { return }
        
        homeParentVc.scrollViewDidScroll(scrollView)
    }
}
