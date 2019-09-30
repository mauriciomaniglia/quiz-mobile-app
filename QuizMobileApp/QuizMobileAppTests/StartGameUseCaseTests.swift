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

}

class QuizGameEngine {
    private let counter: CounterSpy
    
    init(counter: CounterSpy) {
        self.counter = counter
    }
}

class CounterSpy {
    var startCounterCallCount = 0
}
