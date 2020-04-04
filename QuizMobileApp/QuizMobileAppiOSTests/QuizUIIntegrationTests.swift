//
//  QuizUIIntegrationTests.swift
//  QuizMobileAppiOSTests
//
//  Created by Mauricio Cesar Maniglia Junior on 27/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp
import QuizMobileAppiOS

class QuizUIIntegrationTests: XCTestCase {
    
    func test_loadActions_requestQuizFromLoader() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer.quizComposedWith(questionLoader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.viewDidAppear(false)
        
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.viewDidAppear(false)
        
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once view is loaded again")
    }
    
    func test_loadingQuestionComponents_areVisibleWhileLoadingQuiz() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer.quizComposedWith(questionLoader: loader)
        
        sut.viewDidAppear(false)
        sut.quizHeaderController.loadViewIfNeeded()
        sut.quizFooterController.loadViewIfNeeded()
        
        XCTAssertEqual(sut.quizHeaderController.questionLabel.text, "-", "Expected loading indicator before question is loaded")
        XCTAssertEqual(sut.quizFooterController.answerCountLabel.text, "-", "Expected loading indicator before question is loaded")
        XCTAssertEqual(sut.quizFooterController.counterLabel.text, "05:00", "Expected timer label to be set correctly before question is loaded")
    }
    
    func test_startGame_isVisibleWhenLoadFinish() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer.quizComposedWith(questionLoader: loader)
        
        sut.viewDidAppear(false)
        sut.quizHeaderController.loadViewIfNeeded()
        sut.quizFooterController.loadViewIfNeeded()
        loader.simulateSuccessfulLoad()
        
        XCTAssertEqual(sut.quizFooterController.statusButton.titleLabel?.text, "start")
    }
    
    private class LoaderSpy: QuestionLoader {
        var loadCallCount = 0
        private var completions = [(QuestionLoaderResult) -> Void]()
        
        func load(completion: @escaping (QuestionLoaderResult) -> Void) {
            loadCallCount += 1
            completions.append(completion)
        }
        
        func simulateSuccessfulLoad() {
            let questionItem = QuestionItem(question: "Some question", answer: ["some answer", "another answser"])
            completions[0](.success([questionItem]))
        }
    }
}
