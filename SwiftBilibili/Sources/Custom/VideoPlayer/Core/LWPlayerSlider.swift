//
//  LWPlayerSlider.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/4/2.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

open class LWPlayerSlider: UISlider {

    open var progressView : UIProgressView
    
    public override init(frame: CGRect) {
        self.progressView = UIProgressView()
        super.init(frame: frame)
        configureSlider()
        
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override open func thumbRect(forBounds bounds: CGRect, trackRect rect: CGRect, value: Float) -> CGRect {
        let rect = super.thumbRect(forBounds: bounds, trackRect: rect, value: value)
        let newRect = CGRect(x: rect.origin.x, y: rect.origin.y + 1, width: rect.width, height: rect.height)
        return newRect
    }
    
    override open func trackRect(forBounds bounds: CGRect) -> CGRect {
        let rect = super.trackRect(forBounds: bounds)
        let newRect = CGRect(origin: rect.origin, size: CGSize(width: rect.size.width, height: 2.0))
        configureProgressView(newRect)
        return newRect
    }
    
    func configureSlider() {
        minimumValue = 0.0
        value = 0.0
        maximumTrackTintColor = UIColor.clear
        minimumTrackTintColor = UIColor.white
        
//        let thumbImage = VGPlayerUtils.imageResource("VGPlayer_ic_slider_thumb")
//        let normalThumbImage = VGPlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 15, height: 15))
//        setThumbImage(normalThumbImage, for: .normal)
//        let highlightedThumbImage = VGPlayerUtils.imageSize(image: thumbImage!, scaledToSize: CGSize(width: 20, height: 20))
//        setThumbImage(highlightedThumbImage, for: .highlighted)
        
        backgroundColor = UIColor.clear
        progressView.tintColor = UIColor.white
        progressView.trackTintColor = UIColor.red
    }
    
    func configureProgressView(_ frame: CGRect) {
        progressView.frame = frame
        insertSubview(progressView, at: 0)
    }
    
    open func setProgress(_ progress: Float, animated: Bool) {
        progressView.setProgress(progress, animated: animated)
    }
    

}
