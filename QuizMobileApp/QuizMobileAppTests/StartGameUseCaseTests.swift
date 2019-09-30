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
        let counter = CounterSpy(seconds: 1)
        _ = QuizGameEngine(counter: counter)
        
        XCTAssertEqual(counter.startCounterCallCount, 0)
    }
    
    func test_startGame_requestToStartTheCounter() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        sut.startGame { }
        
        XCTAssertEqual(counter.startCounterCallCount, 1)
    }
    
    func test_startGame_deliversCounterStartMessageWhenSecondsIsGreaterThanZero() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame {
            counterStartMessage += 1
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }

}

class QuizGameEngine {
    private let counter: CounterSpy
    
    init(counter: CounterSpy) {
        self.counter = counter
    }
    
    func startGame(completion: @escaping () -> Void) {
        self.counter.start(completion: completion)
    }
}

class CounterSpy {
    var startCounterCallCount = 0
    var seconds = 0
    var messages = [() -> Void]()
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    func start(completion: @escaping () -> Void) {
        startCounterCallCount += 1
        messages.append(completion)
    }
    
    func startGameMessage(at index: Int = 0) {
        messages[index]()
    }
}
