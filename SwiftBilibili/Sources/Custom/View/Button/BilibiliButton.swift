//
//  BilibiliButton.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/6.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

enum BilibiliButtonImagePosition {
    case left
    case right
    case top
    case bottom
}

class BilibiliButton: UIButton {

    var space: CGFloat = 5 {
        didSet {
           self.setNeedsLayout()
        }
    }
    
    var imagePosition: BilibiliButtonImagePosition = .left {
        didSet {
           self.setNeedsLayout()
        }
    }
    
    var imageSize: CGSize = .zero {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        if self.bounds.isEmpty { return }
        
        guard let imageView = imageView,
              let titleLabel = titleLabel
        else { return }
        
        resizeSubviews(titleLabel: titleLabel,imageView: imageView)
        
        switch imagePosition {
        case .left:
            layoutSubviewsForImagePositionLeft(titleLabel: titleLabel, imageView: imageView)
        case .right:
            layoutSubViewsForImagePositionRight(titleLabel: titleLabel, imageView: imageView)
        case .top:
            layoutSubViewsForImagePositionTop(titleLabel: titleLabel, imageView: imageView)
        case .bottom:
            layoutSubViewsForImagePositionBottom(titleLabel: titleLabel, imageView: imageView)
        }
    }

    private func resizeSubviews(titleLabel: UILabel,imageView: UIImageView) {
        
        imageView.size = imageSize != .zero ? imageSize : imageView.image?.size ?? .zero
        titleLabel.sizeToFit()
        
        switch imagePosition {
        case .left,.right:
            if titleLabel.width > self.width - space - imageView.width {
                titleLabel.width = self.width
            }
        case .top,.bottom:
            if titleLabel.width > self.width {
                titleLabel.width = self.width
            }
        }
    }
    
    func layoutSubviewsForImagePositionLeft(titleLabel: UILabel,imageView: UIImageView) {
        
        switch self.contentHorizontalAlignment {
        case .right:
            titleLabel.x = self.width - titleLabel.width
            titleLabel.y = (self.height - titleLabel.height) * 0.5
            
            imageView.x = self.width - titleLabel.width - space - imageView.width
            imageView.y = (self.height - imageView.height) * 0.5;
        case .left:
            imageView.x = 0
            imageView.y = (self.height - imageView.height) * 0.5
            
            titleLabel.x = imageView.right + space
            titleLabel.y = (self.height - titleLabel.height) * 0.5
        case .center:
            imageView.x = self.width * 0.5 - (titleLabel.width + space + imageView.width) * 0.5
            imageView.y = (self.height - imageView.height) * 0.5
            
            titleLabel.x = space + imageView.right
            titleLabel.y = (self.height - titleLabel.height) * 0.5
        default: break
        }
    }
    
    func layoutSubViewsForImagePositionRight(titleLabel: UILabel,imageView: UIImageView) {
        
        switch self.contentHorizontalAlignment {
        case .right:
            imageView.x = self.width - imageView.width
            imageView.y = (self.height - imageView.height) * 0.5
            
            titleLabel.x = self.width - imageView.width - space - titleLabel.width
            titleLabel.y = (self.height - titleLabel.height) * 0.5
        case .left:
            titleLabel.x = 0
            titleLabel.y = (self.height - titleLabel.height) * 0.5
            
            imageView.x = space + titleLabel.width
            imageView.y = (self.height - imageView.height) * 0.5
        case .center:
            titleLabel.x = self.width * 0.5 - (titleLabel.width + space + imageView.width) * 0.5
            titleLabel.y = (self.height - titleLabel.height) * 0.5
            
            imageView.x = titleLabel.x + titleLabel.width + space
            imageView.y = (self.height - imageView.height) * 0.5
        default:break
      }
  }
    
    func layoutSubViewsForImagePositionTop(titleLabel: UILabel,imageView: UIImageView) {
        
        switch self.contentVerticalAlignment {
        case .top:
            imageView.centerX = self.width * 0.5
            imageView.y = 0
            
            titleLabel.y = imageView.bottom + space
            titleLabel.centerX = self.width * 0.5
        case .bottom:
            titleLabel.centerX = self.width * 0.5
            titleLabel.y = self.height - titleLabel.height
            
            imageView.x = space + titleLabel.width
            imageView.y = self.height - (imageView.height + titleLabel.height + space)
        case .center:
            titleLabel.centerX = self.width * 0.5
            titleLabel.y = imageView.bottom + space
            
            imageView.centerX = self.width * 0.5
            imageView.y = (self.height - imageView.height - titleLabel.height - space) * 0.5
        default:break
        }
    }
    
    func layoutSubViewsForImagePositionBottom(titleLabel: UILabel,imageView: UIImageView) {
        
        switch self.contentVerticalAlignment {
        case .top:
            imageView.centerX = self.width * 0.5
            imageView.y = titleLabel.bottom + space
            
            titleLabel.y = 0
            titleLabel.centerX = self.width * 0.5
        case .bottom:
            titleLabel.centerX = self.width * 0.5
            titleLabel.y = self.height - (titleLabel.height + imageView.height + space)
            
            imageView.centerX = self.width * 0.5
            imageView.y = self.height - imageView.height
        case .center:
            titleLabel.centerX = self.width * 0.5
            titleLabel.y = (self.height - imageView.height - titleLabel.height - space) * 0.5
            
            imageView.centerX = self.width * 0.5
            imageView.y = titleLabel.bottom + space
        default:break
        }
    }
}
