//
//  BilibiliBannerView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/1/21.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import FSPagerView
import RxSwift

private let cellID = "cellID"

final class BilibiliBannerView: UIView {
    
    private var bannerModels: [BilibiliBannerModel] = []
    
    private let pagerView = FSPagerView().then{
        
        $0.register(BilibiliBannerCell.self, forCellWithReuseIdentifier: cellID)
        $0.automaticSlidingInterval = 3.0
    }
    
    private let pageControl = FSPageControl().then {
        $0.contentHorizontalAlignment = .right
        $0.contentInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        $0.setFillColor(.db_white, for: .normal)
        $0.setFillColor(.db_pink, for: .selected)
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(pagerView)
        pagerView.addSubview(pageControl)
        
        pagerView.dataSource = self
        pagerView.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reloadData(bannerModels:[BilibiliBannerModel]) {
    
        self.bannerModels = bannerModels
        
        pageControl.numberOfPages = bannerModels.count
        pagerView.isInfinite = bannerModels.count != 1
        
        pageControl.isHidden = !pagerView.isInfinite
    
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        pagerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        pageControl.snp.makeConstraints { (make) in
            
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(20)
        }
        
    }
}

extension BilibiliBannerView: FSPagerViewDataSource {
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return bannerModels.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: cellID, at: index) as! BilibiliBannerCell
        let bannerModel = bannerModels[index]
        cell.imageView?.setImage(with: URL(string:bannerModel.imageUrl), placeholder: UIImage.placeholderImage(bgSize: CGSize(width: kScreenWidth-2*kCollectionItemPadding, height: kBannerHeight)))
        cell.adLabel.isHidden = !bannerModel.isAd
        
        return cell
    }
}

extension BilibiliBannerView: FSPagerViewDelegate {
    
    func pagerViewDidScroll(_ pagerView: FSPagerView) {
        guard pageControl.currentPage != pagerView.currentIndex else {
            return
        }
        pageControl.currentPage = pagerView.currentIndex
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        BilibiliRouter.push(bannerModels[index].link)
    }
}
