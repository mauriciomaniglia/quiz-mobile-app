//
//  CounterSpy.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 01/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation
import QuizMobileApp

public class CounterSpy: Counter {
    var messages = [CounterResult]()
    var seconds = 0
    private var completion: ((CounterResult) -> Void)?
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    public func start(completion: @escaping (CounterResult) -> Void) {
        guard seconds > 0 else { return }
        messages.append(.start)
        self.completion = completion
        
        while seconds > 0 {
            messages.append(.currentSecond(seconds))
            seconds -= 1
        }
    }
    
    public func reset() {
        messages.append(.reset)
    }
    
    public func stop() {
        completion?(.stop)
    }
    
    func startGameMessage() {
        completion?(.start)
    }
    
    func sendCurrentSecond() {
        completion?(.currentSecond(seconds))
    }
    
    func sendStopMessage() {
        completion?(.stop)
    }
}
