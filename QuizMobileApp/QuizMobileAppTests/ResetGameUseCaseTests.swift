//
//  ResetGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 20/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class ResetGameUseCaseTest: XCTestCase {
    
    func test_init_doesNotResetCounter() {
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.resetCallsCount, 0)
    }
    
    // MARK - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["Answer1"])
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }
    
    private class CounterSpy: QuizCounter {
        var startCallsCount = 0
        var resetCallsCount = 0
        
        func start() {
            startCallsCount += 1
        }
        
        func reset() {
            
        }
        
        func stop() {
            
        }
    }
}
