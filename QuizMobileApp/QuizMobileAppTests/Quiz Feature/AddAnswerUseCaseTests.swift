//
//  AddAnswerUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 20/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class AddAnswerUseCaseTests: XCTestCase {
    
    func test_addAnswer_deliversUserAnswer() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.addAnswer("AnyAnswer")
        sut.counterSeconds(1)
        
        XCTAssertEqual(delegate.gameStatus?.userAnswers, ["AnyAnswer"])
    }
    
    func test_addAnswer_withPreviousAnswer_doNotOverrideCurrentAnswer() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.addAnswer("Answer1")
        sut.addAnswer("Answer2")
        sut.counterSeconds(1)
        
        XCTAssertEqual(delegate.gameStatus?.userAnswers, ["Answer1", "Answer2"])
    }
    
    func test_addAnswer_withRepeatedAnswer_doNotInsertNewAnswer() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.addAnswer("Answer")
        sut.addAnswer("Answer")
        sut.counterSeconds(1)
        
        XCTAssertEqual(delegate.gameStatus?.userAnswers, ["Answer"])
    }
    
    func test_addAnswer_withSpace_insertAnswerWithNoSpace() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.addAnswer("  Answer ")
        sut.counterSeconds(1)
        
        XCTAssertEqual(delegate.gameStatus?.userAnswers, ["Answer"])
    }
    
    func test_addAnswer_withSpaceInRepeatedAnswer_doNotInsertAnswer() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.addAnswer("Answer")
        sut.addAnswer(" Answer ")
        sut.counterSeconds(1)
        
        XCTAssertEqual(delegate.gameStatus?.userAnswers, ["Answer"])
    }
    
    func test_addAnswer_withOnlySpaces_doNotInsertAnswer() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.addAnswer("  ")
        sut.counterSeconds(1)
        
        XCTAssertEqual(delegate.gameStatus?.userAnswers, [])
    }
    
    func test_addAnswer_empty_doNotInsertAnswer() {
        let (sut, _) = makeSUT()
        let delegate = GameDelegateSpy()
        sut.delegate = delegate
        
        sut.start()
        sut.addAnswer("Answer")
        sut.addAnswer("")
        sut.counterSeconds(1)
        
        XCTAssertEqual(delegate.gameStatus?.userAnswers, ["Answer"])
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
