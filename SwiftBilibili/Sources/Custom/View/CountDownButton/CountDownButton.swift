//
//  CountDownButton.swift
//  SwiftBilibili
//
//  Created by 罗文 on 2018/6/13.
//  Copyright © 2018年 罗文. All rights reserved.
//

import UIKit

final class CountDownButton: UIButton {

    var countDownButtonHandle: ((CountDownButton)->())?
    var countDownChanging: ((CountDownButton,Int)->NSAttributedString)?
    var countDownFinished: ((CountDownButton,Int)->NSAttributedString)?
    
    
    var second = 0
    
    var totalSecond = 0

    var timer: Timer?
    
    var startDate: Date?
    
    func countDownButtonClick(_ countDownButtonHandle:((CountDownButton)->())?) {
        
        self.countDownButtonHandle = countDownButtonHandle
        
        self.addTarget(self, action: #selector(clicked), for: .touchUpInside)
    }
    
    @objc private func clicked() {
        
        if let block = self.countDownButtonHandle {
            block(self)
        }
    }
    
    func startCountDownWithSecond(totalSecond:Int) {
        
        self.totalSecond = totalSecond
        self.second = totalSecond
        
        self.timer = Timer.init(timeInterval: TimeInterval(1), target: self, selector: #selector(timerStart), userInfo: nil, repeats: true)
        self.startDate = Date()
        self.timer?.fireDate = Date.distantPast
        RunLoop.current.add(self.timer!, forMode: .commonModes)
    }
    
    @objc private func timerStart() {
        
        guard let startDate = self.startDate else { return }
        
        let deltaTime = Date().timeIntervalSince(startDate)
        
        self.second = self.totalSecond - Int(deltaTime)
        
        if self.second < 1 {
            stopCountDown()
        }else{
            
            if let countDownChanging = self.countDownChanging {
                dispatch_async_safely_to_main_queue {[unowned self] in

                    let title = countDownChanging(self,self.second)
                    self.setAttributedTitle(title, for: .normal)
                    self.setAttributedTitle(title, for: .disabled)
                }
            }else{
                let title = NSAttributedString(string: "\(self.second)秒")
                self.setAttributedTitle(title, for: .normal)
                self.setAttributedTitle(title, for: .disabled)
            }
        }
    }

    private func stopCountDown() {

        guard let timer = self.timer else { return }
        
        if timer.isValid {
            
            timer.invalidate()
            
            self.second = self.totalSecond
            if let countDownFinished = self.countDownFinished {
                dispatch_async_safely_to_main_queue {[unowned self] in
                    let title = countDownFinished(self,self.totalSecond)
                    self.setAttributedTitle(title, for: .normal)
                    self.setAttributedTitle(title, for: .disabled)
                }
            }else{
                self.setAttributedTitle(NSAttributedString(string: "重新获取"), for: .normal)
                self.setAttributedTitle(NSAttributedString(string: "重新获取"), for: .disabled)
            }
        }
    }
    
    func countDownChanging(_ countDownChanging:((CountDownButton,Int)->NSAttributedString)?) {
        self.countDownChanging = countDownChanging
    }
    
    func countDownFinished(_ countDownFinished:((CountDownButton,Int)->NSAttributedString)?) {
        self.countDownFinished = countDownFinished
    }

}
