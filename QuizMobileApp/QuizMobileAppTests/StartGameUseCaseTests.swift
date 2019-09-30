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
        let counter = CounterSpy()
        _ = QuizGameEngine(counter: counter)
        
        XCTAssertEqual(counter.startCounterCallCount, 0)
    }
    
    func test_startGame_requestToStartTheCounter() {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter)
        
        sut.startGame()
        
        XCTAssertEqual(counter.startCounterCallCount, 1)
    }

}

class QuizGameEngine {
    private let counter: CounterSpy
    
    init(counter: CounterSpy) {
        self.counter = counter
    }
    
    func startGame() {
        self.counter.start()
    }
}

class CounterSpy {
    var startCounterCallCount = 0
    
    func start() {
        startCounterCallCount += 1
    }
}
