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
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.callsCount, 0)
    }
    
    func test_start_startCounter() {
        let (sut, counter) = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(counter.callsCount, 1)
    }
    
    func test_startTwice_startCounterTwice() {
        let (sut, counter) = makeSUT()
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(counter.callsCount, 2)
    }
    
    // MARK - Helpers
    
    private func makeSUT() -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["Answer1"])
        
        return (sut, counter)
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
