//
//  TogetherDislikePopOverView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/2/2.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

import RxSwift

struct ActionData {
    var title: String?
    var image: UIImage?
    
    init(title: String?, image: UIImage?) {
        self.title = title
        self.image = image
    }
}

struct DislikeFooterData {
    var upName: String?
    var zoneName: String?
    var remarkName: String?
    
    init(upName: String?, zoneName: String?, remarkName: String?) {
        self.upName = upName
        self.zoneName = zoneName
        self.remarkName = remarkName
    }
}


final class TogetherDislikePopOverView: PopOverView<PopOverViewCell,ActionData,UIView,Void, TogetherDislikeFooter,DislikeFooterData,UITableViewHeaderFooterView,Void> {

    var dislikeTapSubject = PublishSubject<TogetherDislikeModel>()
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        settings.arrowView.edgeAlignment = true
        settings.animation.tapShouldAnimated = true
        
        cellSpec = .nibFile(nibName: "PopOverViewCell", bundle: nil, height:{ _ in kDislikeCellHeight })
        footerSpec = .nibFile(nibName: "TogetherDislikeFooter", bundle: nil, height:{ _ in kDislikeFooterHeight})
        
        onConfigureCellForAction = {[unowned self] cell, action, indexPath in
            cell.reloadData(title:action.data?.title,image:action.data?.image)
            if let _ = self.footerData, let _ = self.footerSpec {
                cell.separatorView.isHidden = false
            }else {
                cell.separatorView.isHidden = indexPath.row == self.tableView.numberOfRows(inSection: indexPath.section) - 1
            }
        }
        onConfigureFooter = {[unowned self] (footer:TogetherDislikeFooter,data:DislikeFooterData) in
           footer.reloadData(upName: data.upName, zoneName: data.zoneName, remarkName: data.remarkName)
           footer.dislikeTapSubject.bind(to: self.dislikeTapSubject).disposed(by: self.rx.disposeBag)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
