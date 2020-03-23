//
//  QuizIntegrationTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 22/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class QuizIntegrationTests: XCTestCase {
    
    func test_start_deliversGameOnStartState() {
        let counter = QuizGameTimer(withSeconds: 1)
        let quizGameEngine = QuizGameEngine(counter: counter, correctAnswers: ["Answer1", "Answer2"])
        let quizGameDelegate = GameSpy()
        let exp = expectation(description: "Wait for counter")
        counter.delegate = quizGameEngine
        quizGameEngine.delegate = quizGameDelegate
        quizGameDelegate.asyncExpectation = exp
                
        quizGameEngine.start()
        
        wait(for: [exp], timeout: 1.0)
        
        XCTAssertEqual(quizGameDelegate.gameStatus?.isGameStarted, true)
        XCTAssertEqual(quizGameDelegate.gameStatus?.isGameFinished, false)
        XCTAssertEqual(quizGameDelegate.gameStatus?.correctAnswers, ["Answer1", "Answer2"])
        XCTAssertEqual(quizGameDelegate.gameStatus?.userAnswers, [])
        XCTAssertEqual(quizGameDelegate.gameStatus?.userHitAllAnswers, false)
    }
    
    func test_start_runsCounterUntilItsFinished() {
        let counter = QuizGameTimer(withSeconds: 1)
        let quizGameEngine = QuizGameEngine(counter: counter, correctAnswers: ["Answer1", "Answer2"])
        let quizGameDelegate = GameSpy()
        let exp = expectation(description: "Wait for counter")
        exp.expectedFulfillmentCount = 2
        counter.delegate = quizGameEngine
        quizGameEngine.delegate = quizGameDelegate
        quizGameDelegate.asyncExpectation = exp
        
        quizGameEngine.start()
        
        wait(for: [exp], timeout: 2.0)
        
        XCTAssertEqual(quizGameDelegate.gameStatus?.currentSeconds, 0)
    }
    
    class GameSpy: QuizGameDelegate {
        var gameStatus: GameStatus?
        var asyncExpectation: XCTestExpectation?
        
        func gameStatus(_ gameStatus: GameStatus) {
            self.gameStatus = gameStatus
            asyncExpectation?.fulfill()
        }
    }
}
