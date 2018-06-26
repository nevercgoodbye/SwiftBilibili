//
//  LWPlayer.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

open class LWPlayer: NSObject {

    public static var showLog = true
    
    open weak var delegate: LWPlayerDelegate?

    open var videoGravity = LWPlayerVideoGravity.aspectFill{
        didSet {
            if let layer = self.playerView?.layer as? AVPlayerLayer{
                layer.videoGravity = AVLayerVideoGravity(rawValue: videoGravity.rawValue)
            }
        }
    }
    
    /// 视频类型
    open var videoType = LWPlayerVideoType.av
    
    /// 设置url会自动播放
    open var autoPlay = true
    
    /// 设备横屏时自动旋转(phone)
    open var autoLandscapeFullScreenLandscape = UIDevice.current.userInterfaceIdiom == .phone
    
    /// 全屏的模式
    open var fullScreenMode = LWPlayerFullScreenMode.landscape
    
    /// 全屏时status bar的样式
    open var fullScreenPreferredStatusBarStyle = UIStatusBarStyle.lightContent
    
    /// 全屏时status bar的背景色
    open var fullScreenStatusbarBackgroundColor = UIColor.black.withAlphaComponent(0.3)
    
    /// 上下滑动屏幕的控制类型
    open var slideTrigger = (left:LWPlayerSlideTrigger.volume,right:LWPlayerSlideTrigger.brightness)
    
    /// 左右滑动屏幕改变视频进度
    open var canSlideProgress = true
    
    /// 嵌入模式的控制皮肤
    open var controlViewForEmbedded : UIView?
    
    /// 浮动模式的控制皮肤
    open var controlViewForFloat : UIView?
    
    /// 全屏模式的控制皮肤
    open var controlViewForFullscreen : UIView?
    
    /// 嵌入模式的容器
    open weak var embeddedContentView: UIView?
    
    /// 嵌入模式的显示隐藏
    open  private(set)  var controlsHidden = false
    
    /// 过多久自动消失控件，设置为<=0不消失
    open var autohiddenTimeInterval: TimeInterval = 5
    
    /// 返回按钮block
    open var backButtonBlock:(( _ fromDisplayMode: LWPlayerDisplayMode) -> Void)?
    
    open  var controlViewForIntercept : UIView? {
        didSet{
            self.updateCustomView()
        }
    }
    
    private var playerView: LWPlayerView?
    open var view: UIView{
        if self.playerView == nil {
            self.playerView = LWPlayerView(controlView: self.controlView)
        }
        return self.playerView!
    }
    private var timeObserver: Any?
    private var timer       : Timer?
    open private(set) var isM3U8 = false
    
    /// 视频截图
    open private(set) var imageGenerator: AVAssetImageGenerator?
    
    /// 视频截图m3u8
    open private(set) var videoOutput: AVPlayerItemVideoOutput?
    
    open private(set) var contentURL :URL?{
        didSet{
            guard let url = contentURL else {
                return
            }
            self.isM3U8 = url.absoluteString.hasSuffix(".m3u8")
        }
    }

    open var isLive: Bool? {
        if let duration = self.duration {
            return duration.isNaN
        }
        return nil
    }
    
    //放置于playerView之上
    open var controlView : UIView?{
        if let view = self.controlViewForIntercept{
            return view
        }
        switch self.displayMode {
        case .embedded:
            return self.controlViewForEmbedded
        case .fullscreen:
            return self.controlViewForFullscreen
        case .float:
            return self.controlViewForFloat
        case .none:
            return self.controlViewForEmbedded
        }
    }
    
    open private(set) var player: AVPlayer? {
        willSet{
            removePlayerObserver()
        }
        didSet{
            addPlayerObserver()
        }
    }

    open private(set) var playerAsset: AVAsset?{
        didSet{
            if oldValue != playerAsset{
                if let playerAsset = playerAsset {
                    self.imageGenerator = AVAssetImageGenerator(asset: playerAsset)
                }else{
                    self.imageGenerator = nil
                }
            }
        }
    }
    
    open private(set) var playerItem: AVPlayerItem?{
        willSet{
            if playerItem != newValue{
                 removePlayerItemObserver()
                 removePlayerNotifications()
            }
        }
        didSet {
            if playerItem != oldValue{
                 addPlayerItemObserver()
                 addPlayerNotifications()
            }
        }
    }
    
    open fileprivate(set) var state = LWPlayerState.unknown {
        
        didSet{
            if oldValue != state {
                playStateDidChange()
            }
        }
    }
    
    open private(set)  var displayMode = LWPlayerDisplayMode.none{
        didSet{
            if oldValue != displayMode{
                (self.controlView as? LWPlayerDelegate)?.player(self, playerDisplayModeDidChange: displayMode)
                self.delegate?.player(self, playerDisplayModeDidChange: displayMode)
            }
        }
    }
    
    open private(set)  var lastDisplayMode = LWPlayerDisplayMode.none

    /// 视频是否正在播放
    open var isPlaying:Bool{
        guard let player = self.player else {
            return false
        }
        return player.rate > Float(0) && player.error == nil
    }
    
    /// 视频长度
    open var duration: TimeInterval? {
        if let  duration = self.player?.duration  {
            return duration
        }
        return nil
    }
    
    /// 视频进度
    open var currentTime: TimeInterval? {
        if let  currentTime = self.player?.currentTime {
            return currentTime
        }
        return nil
    }
    
    /// 视频播放速率
    open var rate: Float{
        get {
            if let player = self.player {
                return player.rate
            }
            return .nan
        }
        set {
            if let player = self.player {
                player.rate = newValue
            }
        }
    }
    
    /// 系统音量
    open var systemVolume: Float{
        get {
            return LWPlayerUtils.systemVolumeSlider.value
        }
        set {
            LWPlayerUtils.systemVolumeSlider.value = newValue
        }
    }
    
    //life cycle
    deinit {
        NotificationCenter.default.removeObserver(self)
        self.timer?.invalidate()
        self.timer = nil
        self.releasePlayerResource()
    }
    
    public override init() {
        super.init()
        self.commonInit()
    }
    
    public init(controlView: UIView?) {
        super.init()
        if controlView == nil{
            self.controlViewForEmbedded = UIView()
        }else{
            self.controlViewForEmbedded = controlView
        }
        self.commonInit()
    }
    
    //MARK: - Public
    open func playWithURL(_ url: URL?,embeddedContentView contentView: UIView? = nil) {
        self.contentURL = url
        self.prepareToPlay()
        if let contentView = contentView {
            self.embeddedContentView = contentView
            self.embeddedContentView!.addSubview(self.view)
            self.view.frame = self.embeddedContentView!.bounds
            self.displayMode = .embedded
        }
    }
    
    open func play(){
        self.state = .playing
        self.player?.play()
    }
    
    open func pause(){
        self.state = .pause
        self.player?.pause()
    }
    
    open func stop() {
        //let lastState = self.state
        self.state = .stopped
        self.player?.pause()
        self.releasePlayerResource()
    }
    
    open func seek(to time: TimeInterval, completionHandler: ((Bool) -> Swift.Void )? = nil) {
        guard let player = self.player else { return }
        let lastState = self.state
        if let currentTime = self.currentTime {
            if currentTime > time {
                self.state = .seekingBackward
            }else if currentTime < time {
                self.state = .seekingForward
            }
        }
        player.seek(to: CMTimeMakeWithSeconds(time,CMTimeScale(NSEC_PER_SEC)), toleranceBefore: kCMTimeZero, toleranceAfter: kCMTimeZero, completionHandler: {  [weak self]  (finished) in
            guard let `self` = self else { return }
            switch self.state {
            case .seekingBackward,.seekingForward:
                self.state = lastState
            default: break
            }
            completionHandler?(finished)
        })
    }
    
    open func updateCustomView(toDisplayMode: LWPlayerDisplayMode? = nil) {
        var nextDisplayMode = self.displayMode
        defer { self.displayMode = nextDisplayMode }
        if toDisplayMode != nil{
            nextDisplayMode = toDisplayMode!
        }
        if let view = self.controlViewForIntercept{
            self.playerView?.controlView = view
            self.displayMode = nextDisplayMode
        }else{
            switch nextDisplayMode {
            case .embedded:
                //playerView加问号，其实不关心playerView存不存在，存在就更新
                if self.playerView?.controlView == nil || self.playerView?.controlView != self.controlViewForEmbedded{
                    if self.controlViewForEmbedded == nil {
//                        self.controlViewForEmbedded = self.controlViewForFullscreen ?? Bundle(for: EZPlayerControlView.self).loadNibNamed(String(describing: EZPlayerControlView.self), owner: self, options: nil)?.last as? EZPlayerControlView
                    }
                }
                self.playerView?.controlView = self.controlViewForEmbedded
                
            case .fullscreen:
                if self.playerView?.controlView == nil || self.playerView?.controlView != self.controlViewForFullscreen{
                    if self.controlViewForFullscreen == nil {
//                        self.controlViewForFullscreen = self.controlViewForEmbedded ?? Bundle(for: EZPlayerControlView.self).loadNibNamed(String(describing: EZPlayerControlView.self), owner: self, options: nil)?.last as? EZPlayerControlView
                    }
                }
                self.playerView?.controlView = self.controlViewForFullscreen
                
            case .float:
                if self.playerView?.controlView == nil || self.playerView?.controlView != self.controlViewForFloat{
                    if self.controlViewForFloat == nil {
//                        self.controlViewForFloat = Bundle(for: EZPlayerFloatView.self).loadNibNamed(String(describing: EZPlayerFloatView.self), owner: self, options: nil)?.last as? UIView
                    }
                }
                self.playerView?.controlView = self.controlViewForFloat
                
                break
            case .none:
                //初始化的时候
                if self.controlView == nil {
                    self.controlViewForEmbedded = LWPlayerControlView()
                }
            }
        }
       
    }
    //MARK: - Private
    private func commonInit() {
        
        updateCustomView()
        
        self.timer?.invalidate()
        self.timer = nil
        
        self.timer = Timer.timerWithTimeInterval(0.5, block: {[weak self] in
            
            guard let `self` = self,
                  let _ = self.player,
                  let playerItem = self.playerItem
            else { return }
            
            if playerItem.isPlaybackLikelyToKeepUp && self.state == .playing {
                self.state = .buffering
            }
            
            if playerItem.isPlaybackLikelyToKeepUp && (self.state == .buffering || self.state == .readyToPlay) {
                self.state = .playing
            }
        }, repeats: true)
        
        RunLoop.current.add(self.timer!, forMode: RunLoopMode.commonModes)
    }
    
    private func prepareToPlay() {
        guard let url = self.contentURL else {
            self.state = .error(.invalidContentURL)
            return
        }
        self.releasePlayerResource()
        self.playerAsset = AVAsset(url: url)
        let keys = ["tracks","duration","commonMetadata","availableMediaCharacteristicsWithMediaSelectionOptions"]
        self.playerItem = AVPlayerItem(asset: self.playerAsset!, automaticallyLoadedAssetKeys: keys)
        self.player = AVPlayer(playerItem: playerItem!)
        if self.playerView == nil {
            self.playerView = LWPlayerView(controlView:self.controlView )
        }
        (self.playerView?.layer as! AVPlayerLayer).videoGravity = AVLayerVideoGravity(rawValue: self.videoGravity.rawValue)
        self.playerView?.config(player: self)
        (self.controlView as? LWPlayerDelegate)?.player(self, showLoading: true)
        self.delegate?.player(self, showLoading: true)
    }
    
    private func resetPlayerResource() {
        self.contentURL = nil
        if let videoOutput = self.videoOutput {
            self.playerItem?.remove(videoOutput)
            self.videoOutput = nil
        }
        self.playerAsset = nil
        self.playerItem = nil
        self.player?.replaceCurrentItem(with: nil)
        self.playerView?.layer.removeAllAnimations()
        (self.controlView as? LWPlayerDelegate)?.player(self, loadedTimeDidChange: 0, totalDuration: 0)
        self.delegate?.player(self, loadedTimeDidChange: 0, totalDuration: 0)
        
        (self.controlView as? LWPlayerDelegate)?.player(self, playedTimeDidChange:0, totalDuration: 0)
        self.delegate?.player(self, playedTimeDidChange: 0, totalDuration: 0)
        
    }
    
    private func releasePlayerResource() {
        if let videoOutput = self.videoOutput {
            self.playerItem?.remove(videoOutput)
            self.videoOutput = nil
        }
        self.playerAsset = nil
        self.playerItem = nil
        self.player?.replaceCurrentItem(with: nil)
        self.playerView?.layer.removeAllAnimations()
        self.playerView?.removeFromSuperview()
        self.playerView = nil
        
        if  let timeObserver = self.timeObserver{
            self.player?.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
    }
}


// MARK: -  Notifation Selector & KVO
extension LWPlayer {
    
    private func removePlayerObserver() {
        
        if let timeObserver = timeObserver {
            player?.removeTimeObserver(timeObserver)
        }
    }
    
    private func removePlayerItemObserver() {

        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty))
        playerItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackLikelyToKeepUp))
    }
    
    private func removePlayerNotifications() {
        NotificationCenter.default.removeObserver(self, name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    private func addPlayerObserver() {
        
        timeObserver = player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, CMTimeScale(NSEC_PER_SEC)), queue: DispatchQueue.main, using: {[weak self] (time) in
            
            guard let `self` = self,
                  let currentTime = self.currentTime,
                  let duration = self.duration
            else { return }
            
            (self.controlView as? LWPlayerDelegate)?.player(self, playedTimeDidChange: currentTime, totalDuration: duration)
            self.delegate?.player(self, playedTimeDidChange: currentTime, totalDuration: duration)
            
        })
    }
    
    private func addPlayerItemObserver() {
        
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: NSKeyValueObservingOptions.new, context: nil)
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.loadedTimeRanges), options: NSKeyValueObservingOptions.new, context: nil)
        // 缓冲区空了，需要等待数据
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackBufferEmpty), options: NSKeyValueObservingOptions.new, context: nil)
        // 缓冲区有足够数据可以播放了
        playerItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.playbackLikelyToKeepUp), options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    private func addPlayerNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(playerItemDidPlayToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: .UIApplicationWillEnterForeground, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: .UIApplicationDidEnterBackground, object: nil)
    }
    
    @objc private func playerItemDidPlayToEnd(_ notification: Notification) {

         self.state = .stopped
        
        
    }
    
    @objc private func applicationWillEnterForeground(_ notification: Notification) {
        

    }
    
    @objc private func applicationDidEnterBackground(_ notification: Notification) {
        
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let item = object as? AVPlayerItem, let keyPath = keyPath {
            
            if item == self.playerItem {
                switch keyPath {
                case #keyPath(AVPlayerItem.status):
                    print("AVPlayerItem's status is changed: \(item.status.rawValue)")
                    if item.status == .readyToPlay {
                        let lastState = self.state
                        if self.state != .playing{
                            self.state = .readyToPlay
                        }
                        //自动播放
                        if self.autoPlay && lastState == .unknown{
                            self.play()
                        }
                    } else if item.status == .failed {
                        self.state = .error(.playerFail)
                    }
                    
                case #keyPath(AVPlayerItem.loadedTimeRanges):
                    print("AVPlayerItem's loadedTimeRanges is changed")
                    
                    let loadedTimeRanges = item.loadedTimeRanges
                    
                    if let bufferTimeRange = loadedTimeRanges.first?.timeRangeValue {
                        
                        let star = bufferTimeRange.start.seconds         // The start time of the time range.
                        let duration = bufferTimeRange.duration.seconds  // The duration of the time range.
                        let bufferTime = star + duration
                        
                        (self.controlView as? LWPlayerDelegate)?.player(self, loadedTimeDidChange: bufferTime, totalDuration: self.duration ?? 0)
                        self.delegate?.player(self, loadedTimeDidChange: bufferTime, totalDuration: self.duration ?? 0)
                    }
                    
                case #keyPath(AVPlayerItem.playbackBufferEmpty):
                    print("AVPlayerItem's playbackBufferEmpty is changed")
                case #keyPath(AVPlayerItem.playbackLikelyToKeepUp):
                    print("AVPlayerItem's playbackLikelyToKeepUp is changed")
                default:
                    break
                }
            }
            
        }
    }
}

// MARK: -  State change
extension LWPlayer {
    
    private func playStateDidChange() {
        
        (self.controlView as? LWPlayerDelegate)?.player(self, playerStateDidChange: state)
        self.delegate?.player(self, playerStateDidChange: state)
        switch state {
        case .buffering:
            (self.controlView as? LWPlayerDelegate)?.player(self, showLoading: true)
            self.delegate?.player(self, showLoading: true)
        case .error(_):
            (self.controlView as? LWPlayerDelegate)?.player(self, showLoading: false)
            self.delegate?.player(self, showLoading: false)
        default:
            (self.controlView as? LWPlayerDelegate)?.player(self, showLoading: false)
            self.delegate?.player(self, showLoading: false)
        }
    }
    
}
