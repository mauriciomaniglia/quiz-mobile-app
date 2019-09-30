//
//  StartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest

class StartGameUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToStartTheCounter() {
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.startCounterCallCount, 0)
    }
    
    func test_startGame_requestToStartTheCounter() {
        let (sut, counter) = makeSUT()
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.startCounterCallCount, 1)
    }
    
    func test_startGame_deliversCounterStartMessageWhenSecondsIsGreaterThanZero() {
        let (sut, counter) = makeSUT()
        
        var counterStartMessage = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .gameStarted:
                counterStartMessage += 1
            case .updateSecond:
                XCTFail("Expected game start message, got \(gameResult) instead")
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }
    
    func test_startGame_doNotDeliversCounterStartMessageTwiceWhenSecondsIsGreaterThanOne() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .gameStarted:
                counterStartMessage += 1
            case .updateSecond:
                XCTFail("Expected game start message, got \(gameResult) instead")
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }
    
    func test_startGame_doNotDeliversCounterStartMessageWithZeroSeconds() {
        let counter = CounterSpy(seconds: 0)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .gameStarted:
                counterStartMessage += 1
            case .updateSecond:
                XCTFail("Expected game start message, got \(gameResult) instead")
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 0)
    }
    
    func test_startGame_deliversCounterCurrentSecondWhenSecondsIsGreaterThanZero() {
        let (sut, counter) = makeSUT()

        var currentSecondCounterResultCount = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .gameStarted:
                XCTFail("Expected updateSecond message, got \(gameResult) instead")
            case .updateSecond:
                currentSecondCounterResultCount += 1
            }
        }
        
        counter.sendCurrentSecond()

        XCTAssertEqual(currentSecondCounterResultCount, 1)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        return (sut, counter)
    }

}

class QuizGameEngine {
    private let counter: CounterSpy
    
    enum QuizGameEngineResult {
        case gameStarted
        case updateSecond(Int)
    }
    
    init(counter: CounterSpy) {
        self.counter = counter
    }
    
    func startGame(completion: @escaping (QuizGameEngineResult) -> Void) {
        self.counter.start { counterResult in
            switch counterResult {
            case .start:
                completion(.gameStarted)
            case let .currentSecond(second):
                completion(.updateSecond(second))
            }
        }
    }
}

class CounterSpy {
    var startCounterCallCount = 0
    var seconds = 0
    var messages = [(CounterResult) -> Void]()
    
    enum CounterResult {
        case start
        case currentSecond(Int)
    }
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    func start(completion: @escaping (CounterResult) -> Void) {
        if seconds > 0 {
            startCounterCallCount += 1
            messages.append(completion)
        }
    }
    
    func startGameMessage(at index: Int = 0) {
        guard messages.count > 0 else { return }
        
        messages[index](.start)
    }
    
    func sendCurrentSecond(at index: Int = 0) {
        guard messages.count > 0 else { return }
        
        messages[index](.currentSecond(seconds))
    }
}
