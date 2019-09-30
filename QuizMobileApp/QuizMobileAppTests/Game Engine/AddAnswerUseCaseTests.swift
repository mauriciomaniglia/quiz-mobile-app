//
//  AddAnswerUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class AddAnswerUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToAddAnswer() {
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.messages.count, 0)
    }
    
    func test_addAnswer_deliversTheNewAnswerAfterSave() {
        let (sut, _) = makeSUT()
        
        var newSavedAnswer = [String]()
        sut.addAnswer("Answer1") { newSavedAnswer = $0 }
        
        XCTAssertEqual(newSavedAnswer, ["Answer1"])
    }
    
    func test_addAnswerTwice_deliversTheNewTwoAnswersAfterSave() {
        let (sut, _) = makeSUT()
        
        var newSavedAnswer = [String]()
        sut.addAnswer("Answer1") { newSavedAnswer = $0 }
        sut.addAnswer("Answer1") { newSavedAnswer = $0 }
        
        XCTAssertEqual(newSavedAnswer, ["Answer1", "Answer1"])
    }
    
    func test_addAnswer_doNotSaveEmptyAnswer() {
        let (sut, _) = makeSUT()
        
        var newSavedAnswer = [String]()
        sut.addAnswer("") { newSavedAnswer = $0 }
        
        XCTAssertEqual(newSavedAnswer, [])
    }
    
    func test_addAnswer_deliversTheSavedAnswersInTheCorrectOrder() {
        let (sut, _) = makeSUT()
        
        var newSavedAnswer = [String]()
        sut.addAnswer("Answer1") { newSavedAnswer = $0 }
        sut.addAnswer("Answer2") { newSavedAnswer = $0 }
        sut.addAnswer("Answer3") { newSavedAnswer = $0 }
        sut.addAnswer("") { newSavedAnswer = $0 }
        sut.addAnswer("Answer4") { newSavedAnswer = $0 }
        
        XCTAssertEqual(newSavedAnswer, ["Answer1", "Answer2", "Answer3", "Answer4"])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }

}
