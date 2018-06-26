//
//  LiveListStarShowView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/1.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import ReusableKit

final class LiveListStarShowView: UIView,NibLoadable {
    
    fileprivate struct Reusable {
        static let starCell = ReusableCell<LiveListStarShowCell>(nibName:"LiveListStarShowCell")
    }
    
    var starShows: [LiveStarShowModel]?
    
    @IBOutlet weak var moreLabel: UILabel!

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.register(Reusable.starCell)
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @IBAction func moreRankClick(_ sender: Any) {
        
        BilibiliRouter.push("http://www.baidu.com")
    }
    
}

extension LiveListStarShowView: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let starShows = self.starShows else {
            return 0
        }
        
        return starShows.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
        let showModel = self.starShows![indexPath.item]
        
        let cell = collectionView.dequeue(Reusable.starCell, for: indexPath)
        
        cell.reloadData(iconUrl: showModel.face, anchorName: showModel.uname, concernNum: showModel.focus_num)
        
        return cell
    }
    
}

extension LiveListStarShowView: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
         BilibiliRouter.push(.live_room)
    }
}
