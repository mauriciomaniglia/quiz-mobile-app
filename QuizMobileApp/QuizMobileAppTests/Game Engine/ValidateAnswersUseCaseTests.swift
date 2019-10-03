//
//  ValidateAnswersUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 01/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class ValidateAnswersUseCaseTests: XCTestCase {
    
    func test_startGame_deliversGameFinishedMessageWhenTheTotalOfGivenAnswersMatchesAllCorrectAnswers() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["Answer1", "Answer2", "Answer3"])
        
        let gameResult = FinalResult(scoreAll: true, savedAnswersCorrect: 3, correctAnswersTotal: 3)
        var receivedMessage = [QuizGameEngineResult]()
        sut.startGame { receivedMessage.append($0) }
        
        sut.addAnswer("Answer1") { _ in }
        sut.addAnswer("Answer2") { _ in }
        sut.addAnswer("Answer3") { _ in }
        
        XCTAssertEqual(receivedMessage, [.gameFinished(gameResult)])
    }
}
