//
//  QuizGameTimer.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public final class QuizGameTimer: Counter {
    public var delegate: CounterDelegate?
    
    private var timer: Timer?
    private var seconds: Int
    private var resetedSeconds: Int
    
    public init(withSeconds seconds: Int) {
        self.seconds = seconds
        self.resetedSeconds = seconds
    }
    
    public func start() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: (#selector(QuizGameTimer.updateSeconds)),
                                     userInfo: nil,
                                     repeats: true)
        delegate?.counterSeconds(seconds)
    }
    
    public func reset() {
        timer?.invalidate()
        seconds = resetedSeconds
        delegate?.counterReseted(seconds)
    }
    
    public func stop() {
        timer?.invalidate()
        delegate?.counterStopped(seconds)
    }
    
    @objc private func updateSeconds() {
        if seconds > 0 {
            delegate?.counterSeconds(seconds)
            seconds -= 1
        } else {
            stop()
        }
    }
}
