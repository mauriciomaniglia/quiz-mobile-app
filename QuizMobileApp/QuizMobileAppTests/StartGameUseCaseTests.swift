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
    
    func test_start_deliversCounterSeconds() {
        let sut = QuizGameTimer(withSeconds: 1)
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        
        XCTAssertEqual(delegate.counterSecondsCalls, 1)
    }
    
    func test_counterSeconds_deliversGameState() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.counterSeconds(1)
        
        XCTAssertNotNil(delegate.gameStatus)
        XCTAssertEqual(delegate.gameStatus?.isGameStarted, true)
        XCTAssertEqual(delegate.gameStatus?.isGameFinished, false)
        XCTAssertEqual(delegate.gameStatus?.correctAnswers, ["Answer1"])
        XCTAssertEqual(delegate.gameStatus?.userAnswers, [])
        XCTAssertEqual(delegate.gameStatus?.userHitAllAnswers, false)
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
        
        func start() {
            startCallsCount += 1
        }
        
        func reset() {
            
        }
        
        func stop() {
            
        }
    }
    
    private class GameDelegateSpy: QuizGameDelegate, QuizCounterDelegate {
        var gameStatus: GameStatus?
        var counterSecondsCalls = 0
        
        func gameStatus(_ gameStatus: GameStatus) {
            self.gameStatus = gameStatus
        }
        
        func counterSeconds(_ seconds: Int) {
            counterSecondsCalls += 1
        }
        
        func counterReseted(_ seconds: Int) {
            
        }
        
        func counterStopped(_ seconds: Int) {
            
        }
    }
}
