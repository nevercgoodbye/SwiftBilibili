//
//  LWPlayerView.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit
import AVFoundation

final class LWPlayerView: UIView {

    //播放器属性
    weak private var player: LWPlayer?
    
    weak var controlView: UIView?{
        didSet{
            if oldValue != controlView{
               resetControlView()
            }
        }
    }
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    //手势属性
    open var panGesture: UIPanGestureRecognizer!
    open var singleTapGesture: UITapGestureRecognizer!
    open var doubleTapGesture: UITapGestureRecognizer!
    private var trigger = LWPlayerSlideTrigger.none
    private var isHorizontalPan = true
    private var currentPosition : TimeInterval?
    private var volumeSlider : UISlider!
    // MARK: - Life cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        
    }
    
    init(controlView: UIView?) {
        super.init(frame: .zero)
        self.controlView = controlView
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.controlView?.frame = self.bounds
    }
    
    // MARK: - public
    func config(player:LWPlayer? = nil) {
        
        if let player = player {
            (self.layer as! AVPlayerLayer).player = player.player
            if let customAction =  self.controlView as? LWPlayerCustomAction{
                customAction.player = player
            }
            self.player = player
        }
    }
    
    
    // MARK: - private
    private func commonInit() {
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.black
        
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth,.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin]
        
        self.controlView?.autoresizingMask = [.flexibleLeftMargin,.flexibleTopMargin,.flexibleRightMargin,.flexibleBottomMargin]
        self.addSubview(self.controlView!)
        
        self.panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.panDirection(_:)))
        self.addGestureRecognizer(self.panGesture)
        self.panGesture.delegate = self
        
        self.singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.singleTapGestureTapped(_:)))
        self.singleTapGesture.delegate = self
        self.singleTapGesture.numberOfTapsRequired = 1
        self.singleTapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(self.singleTapGesture)
        
        self.doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doubleTapGestureTapped(_:)))
        self.doubleTapGesture.delegate = self
        self.doubleTapGesture.numberOfTapsRequired = 2
        self.doubleTapGesture.numberOfTouchesRequired = 1
        self.addGestureRecognizer(self.doubleTapGesture)
        
        self.singleTapGesture.require(toFail: self.doubleTapGesture)
    }
    
    private func resetControlView() {
        controlView?.removeFromSuperview()
        self.addSubview(controlView!)
        self.setNeedsDisplay()
        if let customAction = controlView as? LWPlayerCustomAction {
            customAction.player = self.player
        }
    }
}

//MARK: - 手势方法
extension LWPlayerView {
    
    @objc private func panDirection(_ pan: UIPanGestureRecognizer) {
        guard let player = self.player else { return }
        let velocityPoint = pan.velocity(in: self)
        switch pan.state {
        case .began:
            let x = fabs(velocityPoint.x)
            let y = fabs(velocityPoint.y)
            if x > y {
               if let horizontalPanDelegate = controlView as? LWPlayerHorizontalPan,player.canSlideProgress {
                  isHorizontalPan = true
                  currentPosition = player.currentTime
                  horizontalPanDelegate.player(player, progressWillChange: currentPosition ?? 0)
               }
            }else {
                isHorizontalPan = false
                if pan.location(in: self).x > self.bounds.size.width / 2 {
                    trigger = player.slideTrigger.right
                } else {
                    trigger = player.slideTrigger.left
                }
            }
        case .changed:
            if isHorizontalPan {
                horizontalMoved(velocityPoint.x)
            }else{
                verticalMoved(velocityPoint.y,player: player, slideType: trigger)
            }
        case .ended:
            if isHorizontalPan{
                if let horizontalPanDelegate = controlView as? LWPlayerHorizontalPan, player.canSlideProgress{
                    if let currentPosition = currentPosition , !currentPosition.isNaN {
                        horizontalPanDelegate.player(player, progressDidChange: currentPosition)
                    }
                }
            }
        default:
            break
        }
    }
    
    @objc private func singleTapGestureTapped(_ sender: UIGestureRecognizer) {
        guard let player = self.player else { return }
        if let gestureRecognizer = controlView as? LWPlayerGestureRecognizer{
            gestureRecognizer.player(player, singleTapGestureTapped: sender as! UITapGestureRecognizer)
        }
    }
    
    @objc private func doubleTapGestureTapped(_ sender: UIGestureRecognizer) {
        guard let player = self.player else { return }
        if let gestureRecognizer = controlView as? LWPlayerGestureRecognizer{
            gestureRecognizer.player(player, doubleTapGestureTapped: sender as! UITapGestureRecognizer)
        }
    }
    
    private func verticalMoved(_ value: CGFloat,player: LWPlayer, slideType: LWPlayerSlideTrigger) {
        
        switch slideType {
        case .volume:
            player.systemVolume -= Float(value / 10000)
        case .brightness:
            UIScreen.main.brightness -= value / 10000
        default:
            break
        }
    }
    
    private func horizontalMoved(_ value: CGFloat) {
        
        guard let player = player,
              let horizontalPanDelegate = controlView as? LWPlayerHorizontalPan,
              player.canSlideProgress
        else {
            return
        }
        
        if let currentPosition = currentPosition,!currentPosition.isNaN,
           let duration = player.duration,!duration.isNaN {
    
           let nextPosition = currentPosition + TimeInterval(value) / 100.0 * (duration/400)
           if nextPosition > duration {
                self.currentPosition = duration
           }else if nextPosition < 0 {
                self.currentPosition = 0
           }else{
                self.currentPosition = nextPosition
           }
           horizontalPanDelegate.player(player, progressDidChange: nextPosition)
        }
    }
}
extension LWPlayerView: UIGestureRecognizerDelegate {
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool{
        guard  let player = self.player else {
            return false
        }
        
        if self.singleTapGesture == gestureRecognizer || self.doubleTapGesture == gestureRecognizer{
            if let customAction =  self.controlView as? LWPlayerCustomAction{//点击控制条
                return  !customAction.autoHidedControlViews.contains(touch.view!) && !customAction.autoHidedControlViews.contains(touch.view!.superview!)
            }
        }else if self.panGesture == gestureRecognizer{
            
            if player.displayMode == .float || player.isLive ?? true {
                return false
            }
            
            return touch.view == self.controlView
        }
        return true
    }
}

