//
//  StartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 17/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class StartGameUseCaseTests: XCTestCase {
    
    func test_init_doesNotStartCounter() {
        let counter = CounterSpy()
        _ = QuizGameEngine(counter: counter, correctAnswers: ["Answer1"])
        
        XCTAssertEqual(counter.callsCount, 0)
    }
    
    func test_start_startCounter() {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["Answer1"])
        
        sut.start()
        
        XCTAssertEqual(counter.callsCount, 1)
    }
    
    private class CounterSpy: QuizCounter {
        var callsCount = 0
        
        func start() {
            callsCount += 1
        }
        
        func reset() {
            
        }
        
        func stop() {
            
        }
    }
}
