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
    
    func test_reset_callsResetCounter() {
        let (sut, counter) = makeSUT()
        
        sut.reset()
        
        XCTAssertEqual(counter.resetCallsCount, 1)
    }
    
    func test_resetTwice_callsResetCounterTwice() {
        let (sut, counter) = makeSUT()
        
        sut.reset()
        sut.reset()
        
        XCTAssertEqual(counter.resetCallsCount, 2)
    }
    
    func test_reset_deliversCounterReseted() {
        let sut = QuizGameTimer(withSeconds: 1)
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.reset()
        
        XCTAssertEqual(delegate.counterResetedCalls, 1)
    }
    
    // MARK - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["Answer1"])
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }        
}
