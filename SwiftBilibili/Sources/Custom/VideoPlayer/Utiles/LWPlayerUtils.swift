//
//  LWPlayerUtils.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/3/30.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit
import MediaPlayer


/// EZPlayerState的相等判断
///
/// - Parameters:
///   - lhs: 左值
///   - rhs: 右值
/// - Returns: 比较结果
public func ==(lhs: LWPlayerState, rhs: LWPlayerState) -> Bool {
    switch (lhs, rhs) {
    case (.unknown,   .unknown): return true
    case (.readyToPlay,   .readyToPlay): return true
    case (.buffering,   .buffering): return true
    case (.bufferFinished,   .bufferFinished): return true
    case (.playing,   .playing): return true
    case (.seekingForward,   .seekingForward): return true
    case (.seekingBackward,   .seekingBackward): return true
    case (.pause,   .pause): return true
    case (.stopped,   .stopped): return true
    case (.error(let a), .error(let b)) where a == b: return true
    default: return false
    }
}

/// EZPlayerState的不相等判断
///
/// - Parameters:
///   - lhs: 左值
///   - rhs: 右值
/// - Returns: 比较结果
public func !=(lhs: LWPlayerState, rhs: LWPlayerState) -> Bool {
    return !(lhs == rhs)
}

public class LWPlayerUtils {

    /// system volume ui
    public static let systemVolumeSlider : UISlider = {
        let volumeView = MPVolumeView()
        volumeView.showsVolumeSlider = true
        volumeView.showsRouteButton = false
        var returnSlider : UISlider!
        for view in volumeView.subviews {
            if let slider = view as? UISlider {
                returnSlider = slider
                break
            }
        }
        return returnSlider
    }()
    
    
    /// fotmat time
    ///
    /// - Parameters:
    ///   - position: video current position
    ///   - duration: video duration
    /// - Returns: formated time string
    public static func formatTime( position: TimeInterval,duration:TimeInterval) -> String{
        guard !position.isNaN && !duration.isNaN else{
            return ""
        }
        let positionHours = (Int(position) / 3600) % 60
        let positionMinutes = (Int(position) / 60) % 60
        let positionSeconds = Int(position) % 60;
        
        let durationHours = (Int(duration) / 3600) % 60
        let durationMinutes = (Int(duration) / 60) % 60
        let durationSeconds = Int(duration) % 60
        if(durationHours == 0){
            return String(format: "%02d:%02d/%02d:%02d",positionMinutes,positionSeconds,durationMinutes,durationSeconds)
        }
        return String(format: "%02d:%02d:%02d/%02d:%02d:%02d",positionHours,positionMinutes,positionSeconds,durationHours,durationMinutes,durationSeconds)
    }
}
