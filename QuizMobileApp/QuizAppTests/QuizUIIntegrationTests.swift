//
//  QuizUIIntegrationTests.swift
//  QuizMobileAppiOSTests
//
//  Created by Mauricio Cesar Maniglia Junior on 27/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import Quiz
import QuizApp

class QuizUIIntegrationTests: XCTestCase {
    
    func test_loadActions_requestQuizFromLoader() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer(questionLoader: loader).quizRootViewController()
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.loadScreen()
        
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.loadScreen()
        
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once view is loaded again")
    }
    
    func test_loadingQuestionComponents_areVisibleWhileLoadingQuiz() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer(questionLoader: loader).quizRootViewController()
        
        sut.loadScreen()
        
        XCTAssertEqual(sut.quizHeaderController.questionLabel.text, "-", "Expected loading indicator before question is loaded")
        XCTAssertEqual(sut.quizFooterController.answerCountLabel.text, "-", "Expected loading indicator before question is loaded")
        XCTAssertEqual(sut.quizFooterController.counterLabel.text, "05:00", "Expected timer label to be set correctly before question is loaded")
    }
    
    func test_startGame_changeGameStateCorrectly() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer(questionLoader: loader).quizRootViewController()
        
        sut.loadScreen()
        loader.simulateSuccessfulLoad()
        
        XCTAssertEqual(sut.quizFooterController.statusButton.title(for: .normal), "start", "Expected start button before game is started")
        XCTAssertFalse(sut.quizHeaderController.answerTextfield.isUserInteractionEnabled, "Expected insert guess to be disable before game is started")
        
        sut.quizFooterController.statusButton.simulateTap()        
        
        XCTAssertEqual(sut.quizFooterController.statusButton.title(for: .normal), "reset", "Expected resert button when game is started")
        XCTAssertTrue(sut.quizHeaderController.answerTextfield.isUserInteractionEnabled, "Expected insert guess to be enable when game is started")
        
        sut.quizFooterController.statusButton.simulateTap()
        
        XCTAssertEqual(sut.quizFooterController.statusButton.title(for: .normal), "start", "Expected start button when game is reseted")
        XCTAssertFalse(sut.quizHeaderController.answerTextfield.isUserInteractionEnabled, "Expected insert guess to be disable when game is reseted")
    }
    
    func test_addGuess_updateUserGuesses() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer(questionLoader: loader).quizRootViewController()
        UIApplication.shared.keyWindow!.rootViewController = sut
        
        sut.loadScreen()
        loader.simulateSuccessfulLoad()
        sut.quizFooterController.statusButton.simulateTap()
        sut.quizHeaderController.answerTextfield.insertText("some answer")
        _ = sut.quizHeaderController.textFieldShouldReturn(sut.quizHeaderController.answerTextfield)
                
        XCTAssertEqual(sut.quizAnswerListController.guessView(at: 0)?.textLabel?.text, "some answer", "Expected last user insertion guess")

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

extension QuizRootViewController {
    func loadScreen() {
        self.viewDidAppear(false)
        self.quizHeaderController.loadViewIfNeeded()
        self.quizAnswerListController.loadViewIfNeeded()
        self.quizFooterController.loadViewIfNeeded()
    }
}

extension UIControl {
    func simulate(event: UIControl.Event) {
        allTargets.forEach { target in
            actions(forTarget: target, forControlEvent: event)?.forEach {
                (target as NSObject).perform(Selector($0))
            }
        }
    }
}

extension UIButton {
    func simulateTap() {
        simulate(event: .touchUpInside)
    }
}

extension QuizAnswerListViewController {
    func guessView(at row: Int) -> UITableViewCell? {
        guard tableView.numberOfRows(inSection: 0) > row else {
            return nil
        }
        
        let ds = tableView.dataSource
        let index = IndexPath(row: row, section: 0)
        return ds?.tableView(tableView, cellForRowAt: index)
    }
}
