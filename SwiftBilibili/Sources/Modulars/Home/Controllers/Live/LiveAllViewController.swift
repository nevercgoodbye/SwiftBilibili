//
//  LiveAllViewController.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/26.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReusableKit
import RxSwift
import RxCocoa

final class LiveAllViewController: BaseCollectionViewController,OutputRefreshProtocol {

    private struct Reusable {
        static let avCell = ReusableCell<LiveAvCell>()
        static let roundRoomCell = ReusableCell<LiveRoundRoomCell>()
    }

    var refreshStatus: BehaviorRelay<BilibiliRefreshStatus> = BehaviorRelay(value: .none)
    
    private let service: HomeServiceType
    private var dataSources: [LiveRecommendAvModel] = []
    private let subType: LiveAllSubType
    
    init(service: HomeServiceType,subType:LiveAllSubType) {
        
        self.service = service
        self.subType = subType
        
        super.init()
        
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(Reusable.avCell)
        collectionView.register(Reusable.roundRoomCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        isEmptyDisplay = false
        
        setupRefreshHeader(collectionView) {[unowned self] in
            self.netRequest()
        }
        
        self.autoSetRefreshStatus(header: collectionView.header).disposed(by: disposeBag)
        
        netRequest()
    }
    
    private func netRequest() {
        
        service.liveAll(subType: subType)
            .asObservable()
            .subscribe(onNext: {[weak self] (models) in
                guard let `self` = self else { return }
                self.hideAnimationView(self.collectionView)
                self.refreshStatus.accept(.endHeaderRefresh)
                self.dataSources = models
                self.isEmptyDisplay = true
                self.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
}

extension LiveAllViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSources.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
            let model = dataSources[indexPath.item]
            
            if subType == .roundroom {
                let cell = collectionView.dequeue(Reusable.roundRoomCell, for: indexPath)
                let reactor = LiveRoundRoomCellReactor(live: LivePartitionAvModel(recommendAvModel: model))
                cell.reactor = reactor
                return cell
            }else{
                let cell = collectionView.dequeue(Reusable.avCell, for: indexPath)
                let reactor = LiveAvCellReactor(live: LivePartitionAvModel(recommendAvModel: model))
                cell.reactor = reactor
                return cell
            }
    }
}

extension LiveAllViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return  UIEdgeInsets(top: kCollectionItemPadding, left: kCollectionItemPadding, bottom: 0, right: kCollectionItemPadding)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let height = subType == .roundroom ? 160.f : kLiveItemHeight
        return CGSize(width: (kScreenWidth - 3*kCollectionItemPadding)/2, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return kCollectionItemPadding
    }
}
