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
    
    private class CounterSpy: QuizCounter {
        var callsCount = 0
        
        func start() {
            
        }
        
        func reset() {
            
        }
        
        func stop() {
            
        }
    }
}
