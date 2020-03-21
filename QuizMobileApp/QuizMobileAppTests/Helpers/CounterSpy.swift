//
//  CounterSpy.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 20/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import QuizMobileApp

class CounterSpy: QuizCounter {
    var startCallsCount = 0
    var resetCallsCount = 0
    var stoppedCallsCount = 0
    
    func start() {
        startCallsCount += 1
    }
    
    func reset() {
        resetCallsCount += 1
    }
    
    func stop() {
        stoppedCallsCount += 1
    }
}
