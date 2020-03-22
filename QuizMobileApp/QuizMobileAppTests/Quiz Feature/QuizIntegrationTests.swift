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
        let counter = QuizGameTimer(withSeconds: 300)
        let quizGameEngine = QuizGameEngine(counter: counter, correctAnswers: ["Answer1", "Answer2"])
        let quizGameDelegate = GameDelegateSpy()
        counter.delegate = quizGameEngine
        quizGameEngine.delegate = quizGameDelegate
                
        quizGameEngine.start()    
        
        XCTAssertEqual(quizGameDelegate.gameStatus?.isGameStarted, true)
        XCTAssertEqual(quizGameDelegate.gameStatus?.isGameFinished, false)
        XCTAssertEqual(quizGameDelegate.gameStatus?.correctAnswers, ["Answer1", "Answer2"])
        XCTAssertEqual(quizGameDelegate.gameStatus?.userAnswers, [])
        XCTAssertEqual(quizGameDelegate.gameStatus?.userHitAllAnswers, false)
    }
}
