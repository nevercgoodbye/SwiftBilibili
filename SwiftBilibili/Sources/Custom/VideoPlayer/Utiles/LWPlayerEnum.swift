//
//  LWPlayerEnum.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/28.
//  Copyright © 2018年 罗文. All rights reserved.
//

public enum LWPlayerError: Error {
    case invalidContentURL
    case playerFail
}

public enum LWPlayerVideoType {
    case live
    case av
}

public enum LWPlayerState {
    case unknown      // 播放前
    case error(LWPlayerError)      // 出现错误
    case readyToPlay    // 可以播放
    case buffering      // 缓冲中
    case bufferFinished // 缓冲完毕
    case playing // 播放
    case seekingForward // 快进
    case seekingBackward // 快退
    case pause // 播放暂停
    case stopped // 播放结束
}

public enum LWPlayerDisplayMode  {
    case none
    case embedded
    case fullscreen
    case float       //小窗
}

public enum LWPlayerFullScreenMode  {
    case portrait
    case landscape
}

public enum LWPlayerVideoGravity : String {
    case aspect = "AVLayerVideoGravityResizeAspect"    //视频值 ,等比例填充，直到一个维度到达区域边界
    case aspectFill = "AVLayerVideoGravityResizeAspectFill"   //等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
    case scaleFill = "AVLayerVideoGravityResize"     //非均匀模式。两个维度完全填充至整个视图区域
}

public enum LWPlayerPlaybackDidFinishReason  {
    case playbackEndTime
    case playbackError
    case stopByUser
}

public enum LWPlayerSlideTrigger{
    case none
    case volume
    case brightness
}
