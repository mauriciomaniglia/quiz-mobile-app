//
//  FinishGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 21/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import Quiz

class FinishGameUseCaseTests: XCTestCase {
    
    func test_addAnswer_stopCounterWhenUserHitAllAnswers() {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["CorrectAnswer1", "CorrectAnswer2"])
        
        sut.start()
        sut.addAnswer("CorrectAnswer1")
        sut.addAnswer("CorrectAnswer2")
        
        XCTAssertEqual(counter.stoppedCallsCount, 1)
    }
    
    func test_stop_deliversCounterStopped() {
        let sut = QuizGameTimer(withSeconds: 1)
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.stop()
        
        XCTAssertEqual(delegate.counterStoppedCalls, 1)
    }
    
    func test_counterStopped_deliversGameOnFinishedState() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.counterStopped(1)
        
        XCTAssertNotNil(delegate.gameStatus)
        XCTAssertEqual(delegate.gameStatus?.isGameStarted, true)
        XCTAssertEqual(delegate.gameStatus?.isGameFinished, true)                
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
