//
//  StartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class StartGameUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToStartTheCounter() {
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.messages.count, 0)
    }
    
    func test_startGame_doNotRequestsToStartTheCounterWithEmptyCorrectAnswers() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.messages, [])
    }
    
    func test_startGame_requestToStartTheCounter() {
        let (sut, counter) = makeSUT()
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.messages, [.start, .currentSecond(1)])
    }
    
    func test_startGame_deliversCounterStartMessageWhenSecondsIsGreaterThanZero() {
        let (sut, counter) = makeSUT()
        
        var messages = [QuizGameEngine.QuizGameEngineResult]()
        sut.startGame { gameResult in
            switch gameResult {
            case .gameStarted:
                messages.append(.gameStarted)
            case .updateSecond:
                messages.append(.updateSecond(1))
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(messages, [.gameStarted])
    }
    
    func test_startGame_doNotDeliversCounterStartMessageTwiceWhenSecondsIsGreaterThanOne() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["CorrectAnswer1", "CorrectAnswer2"])
        
         var messages = [QuizGameEngine.QuizGameEngineResult]()
         sut.startGame { gameResult in
             switch gameResult {
             case .gameStarted:
                 messages.append(.gameStarted)
             case .updateSecond:
                 messages.append(.updateSecond(1))
             }
         }
        
        counter.startGameMessage()
        
        XCTAssertEqual(messages, [.gameStarted])
    }
    
    func test_startGame_doNotDeliversCounterStartMessageWithZeroSeconds() {
        let counter = CounterSpy(seconds: 0)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        
        var messages = [QuizGameEngine.QuizGameEngineResult]()
        sut.startGame { gameResult in
            switch gameResult {
            case .gameStarted:
                messages.append(.gameStarted)
            case .updateSecond:
                messages.append(.updateSecond(1))
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(messages, [])
    }
    
    func test_startGame_requestsCounterCurrentSecondWhenSecondsIsGreaterThanZero() {
        let (sut, counter) = makeSUT()
        
        sut.startGame { _ in }

        XCTAssertEqual(counter.messages, [.start, .currentSecond(1)])
    }
    
    func test_startGame_requestsCounterCurrentSecondTwiceWhenSecondIsEqualToTwo() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["CorrectAnswer1", "CorrectAnswer2"])
        
        sut.startGame { _ in }

        XCTAssertEqual(counter.messages, [.start, .currentSecond(2), .currentSecond(1)])
    }
    
    func test_startGame_doesNotDeliverAfterSUTInstanceHasBeenDeallocated() {
        let counter = CounterSpy(seconds: 2)
        var sut: QuizGameEngine? = QuizGameEngine(counter: counter, correctAnswers: [])
        
        var capturedResults = [QuizGameEngine.QuizGameEngineResult]()
        sut?.startGame { capturedResults.append($0)}
        
        sut = nil
        
        counter.startGameMessage()
        
        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["CorrectAnswer1", "CorrectAnswer2"])
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }
}
