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
    
    func test_start_deliversGameOnStartState() {
        let counter = QuizGameTimer(withSeconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["Answer1"])
        let gameDelegate = GameDelegateSpy()
        counter.delegate = sut
        sut.delegate = gameDelegate
        
        sut.start()        
        
        XCTAssertNotNil(gameDelegate.gameStatus)
        XCTAssertEqual(gameDelegate.gameStatus?.isGameStarted, true)
        XCTAssertEqual(gameDelegate.gameStatus?.isGameFinished, false)        
        XCTAssertEqual(gameDelegate.gameStatus?.correctAnswers, ["Answer1"])
        XCTAssertEqual(gameDelegate.gameStatus?.userAnswers, [])
        XCTAssertEqual(gameDelegate.gameStatus?.userHitAllAnswers, false)
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
        var callsCount = 0
        
        func start() {
            callsCount += 1
        }
        
        func reset() {
            
        }
        
        func stop() {
            
        }
    }
    
    private class GameDelegateSpy: QuizGameDelegate {
        var gameStatus: GameStatus?
        
        func gameStatus(_ gameStatus: GameStatus) {
            self.gameStatus = gameStatus
        }
    }
}
