//
//  LiveListCategoryView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/3.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReusableKit
import RxSwift

final class LiveListCategoryView: UIView {

    fileprivate struct Reusable {
        static let categoryNameCell = ReusableCell<LiveCategoryNameCell>()
    }
    
    var partitionNames: [Int] = []
    
    var collectionView: GesConflictCollectionView?
    
    let collectionViewLayout = UICollectionViewFlowLayout().then{
        
        $0.scrollDirection = .horizontal
        $0.minimumLineSpacing = 30
        $0.minimumInteritemSpacing = 0
    }
    
    let addButton = UIButton().then{
        $0.setTitle("+", for: .normal)
        $0.setTitleColor(.lightGray, for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        $0.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 4, 0)
    }
    
    let bottomLine = UIView().then{
        $0.backgroundColor = .db_lightGray
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCollectionView()
        addSubview(addButton)
        addSubview(bottomLine)
        
        addButton.rx.tap.subscribe(onNext: { (_) in
            
            if !LocalManager.userInfo.isLogin {
                BilibiliRouter.open(.login)
            }
            
        }).disposed(by: rx.disposeBag)
        
    }
    
    func setupCollectionView() {
        let collectionView = GesConflictCollectionView(
            frame:.zero,
            collectionViewLayout:collectionViewLayout
            )
        collectionView.bounces = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .clear
        collectionView.register(Reusable.categoryNameCell)
        collectionView.dataSource = self
        collectionView.delegate = self
        addSubview(collectionView)
        self.collectionView = collectionView
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        addButton.snp.makeConstraints { (make) in
            make.right.top.bottom.equalToSuperview()
            make.width.equalTo(40)
        }
        
        bottomLine.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
        collectionView!.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.bottom.equalTo(bottomLine.snp.top)
            make.right.equalTo(addButton.snp.left)
        }
    }
}
extension LiveListCategoryView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let partitionType = LivePartitionType(rawValue: partitionNames[indexPath.row]) {
            switch partitionType {
            case .attention:
                if !LocalManager.userInfo.isLogin {
                    BilibiliRouter.open(.login)
                }
            default:
                BilibiliRouter.push(.live_partition(id: partitionType.rawValue))
            }
        }
    }
}
extension LiveListCategoryView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return partitionNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeue(Reusable.categoryNameCell, for: indexPath)
        
        let partitionType = LivePartitionType(rawValue: partitionNames[indexPath.row])!
        
        cell.reloadData(title: partitionType.title)
        
        return cell
    }
}

extension LiveListCategoryView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let partitionType = LivePartitionType(rawValue: partitionNames[indexPath.row])!
        
        let itemWidth = partitionType.title.width(with: UIFont.systemFont(ofSize: 14))
        
        return CGSize(width:itemWidth,height: 39)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: 0, left: kCollectionItemPadding, bottom: 0, right: 0)
    }
    
    
}

final class LiveCategoryNameCell: BaseCollectionViewCell {
    
    let titleLabel = UILabel().then{
        $0.textColor = UIColor.lightGray
        $0.font = UIFont.systemFont(ofSize: 14)
        $0.textAlignment = .center
    }
    
    override func initialize() {
        contentView.addSubview(titleLabel)
    }
    
    func reloadData(title:String) {
        titleLabel.text = title
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}



