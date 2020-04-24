//
//  StartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 17/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import Quiz

class StartGameUseCaseTests: XCTestCase {
    
    func test_init_doesNotStartCounter() {
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.startCallsCount, 0)
    }
    
    func test_start_startCounter() {
        let (sut, counter) = makeSUT()
        
        sut.start()
        
        XCTAssertEqual(counter.startCallsCount, 1)
    }
    
    func test_startTwice_startCounterTwice() {
        let (sut, counter) = makeSUT()
        
        sut.start()
        sut.start()
        
        XCTAssertEqual(counter.startCallsCount, 2)
    }
    
    func test_counterSeconds_deliversGameState() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.counterSeconds(1)
        
        XCTAssertNotNil(delegate.gameStatus)
        XCTAssertEqual(delegate.gameStatus?.isGameStarted, true)
        XCTAssertEqual(delegate.gameStatus?.isGameFinished, false)
        XCTAssertEqual(delegate.gameStatus?.correctAnswers, ["Answer1"])
        XCTAssertEqual(delegate.gameStatus?.userAnswers, [])
        XCTAssertEqual(delegate.gameStatus?.userHitAllAnswers, false)
    }
    
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
    
    func test_counterReseted_deliversGameOnResetState() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.counterReseted(1)
        
        XCTAssertNotNil(delegate.gameStatus)
        XCTAssertEqual(delegate.gameStatus?.isGameStarted, false)
        XCTAssertEqual(delegate.gameStatus?.isGameFinished, false)
        XCTAssertEqual(delegate.gameStatus?.correctAnswers, ["Answer1"])
        XCTAssertEqual(delegate.gameStatus?.userAnswers, [])
        XCTAssertEqual(delegate.gameStatus?.userHitAllAnswers, false)
    }
    
    func test_reset_withTwoUserAnswers_deliversGameStateWithEmptyUserAnswers() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
                
        sut.addAnswer("Answer1")
        sut.addAnswer("Answer2")
        sut.reset()
        sut.counterReseted(1)
                
        XCTAssertEqual(delegate.gameStatus?.userAnswers, [])
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
