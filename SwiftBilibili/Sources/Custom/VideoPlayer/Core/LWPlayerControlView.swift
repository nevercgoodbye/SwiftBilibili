//
//  LWPlayerControlView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/30.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

class LWPlayerControlView: UIView {

    lazy var topView: UIImageView = {
        let topView = UIImageView()
        topView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return topView
    }()
    
    lazy var bottomView: UIImageView = {
        let bottomView = UIImageView()
        bottomView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        return bottomView
    }()
    
    lazy var backButton: UIButton = {
        let backButton = UIButton()
        return backButton
    }()
    
    lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = UIColor.white
        return titleLabel
    }()
    
    lazy var pauseButton: UIButton = {
        let pauseButton = UIButton()
        return pauseButton
    }()
    
    lazy var currentTimeLabel: UILabel = {
        let currentTimeLabel = UILabel()
        currentTimeLabel.textColor = UIColor.white
        currentTimeLabel.font = UIFont.systemFont(ofSize: 13)
        return currentTimeLabel
    }()
    
    lazy var totalTimeLabel: UILabel = {
        let totalTimeLabel = UILabel()
        totalTimeLabel.textColor = UIColor.white
        totalTimeLabel.font = UIFont.systemFont(ofSize: 13)
        return totalTimeLabel
    }()
    
    lazy var timeSlider: LWPlayerSlider = {
        let timeSlider = LWPlayerSlider()
        return timeSlider
    }()
    
    lazy var fullScreenButton: UIButton = {
        let fullScreenButton = UIButton()
        return fullScreenButton
    }()
    
    weak var player: LWPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(topView)
        addSubview(bottomView)
        topView.addSubview(backButton)
        topView.addSubview(titleLabel)
        bottomView.addSubview(pauseButton)
        bottomView.addSubview(currentTimeLabel)
        bottomView.addSubview(timeSlider)
        bottomView.addSubview(totalTimeLabel)
        bottomView.addSubview(fullScreenButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        topView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(50)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(50)
        }
        
        backButton.snp.makeConstraints { (make) in
            make.left.equalTo(10).priority(750)
            make.centerY.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(backButton.snp.right).offset(10).priority(1000)
            make.centerY.equalToSuperview()
        }
        
        pauseButton.snp.makeConstraints { (make) in
            make.left.equalTo(backButton)
            make.centerY.equalToSuperview()
        }
        
        currentTimeLabel.snp.makeConstraints { (make) in
            make.left.equalTo(pauseButton.snp.right).offset(10)
            make.centerY.equalToSuperview()
        }
        
        fullScreenButton.snp.makeConstraints { (make) in
            make.right.equalTo(-10)
            make.centerY.equalToSuperview()
        }
        
        totalTimeLabel.snp.makeConstraints { (make) in
            make.right.equalTo(fullScreenButton.snp.left).offset(-10)
            make.centerY.equalToSuperview()
        }
        
        timeSlider.snp.makeConstraints { (make) in
            make.left.equalTo(currentTimeLabel.snp.right).offset(5)
            make.right.equalTo(totalTimeLabel.snp.left).offset(-5)
            make.centerY.equalToSuperview()
        }
    }
}

extension LWPlayerControlView: LWPlayerDelegate {
    
    func player(_ player: LWPlayer, playerStateDidChange state: LWPlayerState) {
        
    }
    
    func player(_ player: LWPlayer, playerDisplayModeDidChange displayMode: LWPlayerDisplayMode) {
        
    }
    
    func player(_ player: LWPlayer, loadedTimeDidChange bufferDuration: TimeInterval, totalDuration: TimeInterval) {
        
        timeSlider.setProgress(Float(bufferDuration/totalDuration), animated: true)
    }
    
    func player(_ player: LWPlayer, playedTimeDidChange currentTime: TimeInterval, totalDuration: TimeInterval) {
        timeSlider.maximumValue = Float(totalDuration)
        timeSlider.value = Float(currentTime)
    }
    
    func player(_ player: LWPlayer, showLoading: Bool) {
        
    }
    
    
    
    
}

