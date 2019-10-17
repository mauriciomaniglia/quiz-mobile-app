//
//  QuizGameTimer.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public final class QuizGameTimer: Counter {
    private var timer: Timer?
    private var seconds: Int
    private var secondsReseted: Int
    private var completion: ((CounterResult) -> Void)?
    
    public init(withSeconds seconds: Int) {
        self.seconds = seconds
        self.secondsReseted = seconds
    }
    
    public func start(completion: @escaping (CounterResult) -> Void) {
        self.completion = completion
        self.completion?(.start)
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(QuizGameTimer.updateSeconds)), userInfo: nil, repeats: true)
    }
    
    public func reset() {
        timer?.invalidate()
        seconds = secondsReseted
        completion?(.reset)
    }
    
    public func stop() {
        timer?.invalidate()
        completion?(.stop)
    }
    
    @objc private func updateSeconds() {
        if seconds > 0 {
            completion?(.currentSecond(seconds))
            seconds -= 1
        } else {
            timer?.invalidate()
            completion?(.stop)
        }
    }
}
