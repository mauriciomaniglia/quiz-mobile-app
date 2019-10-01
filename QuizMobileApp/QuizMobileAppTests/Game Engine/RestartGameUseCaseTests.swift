//
//  RestartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class RestartGameUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToRestartGame() {
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.messages.count, 0)
    }
    
    func test_restartGame_deletesSavedAnswers() {
        let (sut, _) = makeSUT()
        var savedAnswers = [String]()
        sut.addAnswer("Answer1") { savedAnswers = $0.savedAnswers }
        sut.addAnswer("Answer2") { savedAnswers = $0.savedAnswers }
        
        sut.restartGame {}
        sut.addAnswer("NewAnswer") { savedAnswers = $0.savedAnswers }
        
        XCTAssertEqual(savedAnswers, ["NewAnswer"])
    }
    
    func test_restartGame_requestsCounterToReset() {
        let (sut, counter) = makeSUT()
        
        sut.restartGame {}
        
        XCTAssertEqual(counter.messages, [.reset])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["Answer1", "Answer2", "Answer3", "Answer4", "Answer5"])
        
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }
    
    private class CounterSpy: Counter {
        var messages = [CounterResult]()
        var seconds = 0
        var startCompletions = [(CounterResult) -> Void]()
        
        init(seconds: Int) {
            self.seconds = seconds
        }
        
        func start(completion: @escaping (CounterResult) -> Void) {
            guard seconds > 0 else { return }
            messages.append(.start)
            
            while seconds > 0 {
                messages.append(.currentSecond(seconds))
                startCompletions.append(completion)
                
                seconds -= 1
            }
        }
        
        func startGameMessage(at index: Int = 0) {
            guard startCompletions.count > 0 else { return }
            
            startCompletions[index](.start)
        }
        
        func sendCurrentSecond(at index: Int = 0) {
            guard startCompletions.count > 0 else { return }
            
            startCompletions[index](.currentSecond(seconds))
        }
        
        func reset() {
            messages.append(.reset)
        }
    }
}
