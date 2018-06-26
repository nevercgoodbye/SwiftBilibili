//
//  DramaRcmdViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/19.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReusableKit
import RxCocoa
import Dollar

final class DramaRcmdViewController: BaseCollectionViewController,OutputRefreshProtocol {

    private struct Reusable {
        static let rcmdCell = ReusableCell<DramaRcmdCell>()
    }
    
    private let service = HomeService(networking: HomeNetworking())
    private let isRcmd: Bool
    private var datasources: [DramaRcmdCellReactor] = []
    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus> = BehaviorRelay(value: .none)
    init(isRcmd:Bool) {
        self.isRcmd = isRcmd
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //布局子类处理
    override func setupConstraints() {}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = isRcmd ? "追番推荐" : "追番"
        
        collectionView.backgroundColor = UIColor.db_gray
        collectionView.frame = self.view.bounds
        collectionView.register(Reusable.rcmdCell)
        collectionView.delegate = self
        collectionView.dataSource = self

        self.isEmptyDisplay = false
        
        if !isRcmd {
            
            setupRefreshHeader(collectionView,.rabbit) {[unowned self] in
                self.netRequest()
            }
            
            self.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
        }
        
        netRequest()
    }

    private func netRequest() {
        
        if isRcmd {
            service.dramaRcmd().asObservable()
                .subscribe(onNext: {[weak self] (rcmdModels) in
                    guard let `self` = self else { return }
                    self.isEmptyDisplay = true
                    self.hideAnimationView(self.collectionView)
                    self.datasources = rcmdModels.enumerated().map{DramaRcmdCellReactor(recommend: $1, service: self.service,isLast:$0 == rcmdModels.count - 1)}
                    self.collectionView.reloadData()
                }).disposed(by: disposeBag)
        }else{
            service.dramaLike(page: 1).asObservable()
                .subscribe(onNext: {[weak self] (likeModels) in
                 guard let `self` = self else { return }
                 self.isEmptyDisplay = true
                 self.refreshStatus.accept(.endHeaderRefresh)
                 self.hideAnimationView(self.collectionView)
                 self.datasources = likeModels.enumerated().map{DramaRcmdCellReactor(like: $1, service: self.service,isLast:$0 == likeModels.count - 1)}
                 self.collectionView.reloadData()
            }).disposed(by: disposeBag)
        }
    }
}

extension DramaRcmdViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
         return self.datasources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
         let cell = collectionView.dequeue(Reusable.rcmdCell, for: indexPath)
         cell.reactor = datasources[indexPath.item]
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension DramaRcmdViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let cellReactor = datasources[indexPath.item]
        
        return Reusable.rcmdCell.class.cellSize(reactor: cellReactor)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {

        return UIEdgeInsets.zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.f
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.f
    }
    
    
}

