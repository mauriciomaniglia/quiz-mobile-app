//
//  QuizUIComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import Quiz
import QuiziOS

public final class QuizUIComposer {
    private let quizQuestionLoader: QuestionLoader
    private var quizGameEngine: QuizGameEngine?
    private var counter = QuizGameTimer(withSeconds: 300)
    private var headerComposer = QuizHeaderComposer()
    private var listComposer = QuizAnswerListComposer()
    private var footerComposer = QuizFooterComposer()
    private let messageComposer = QuizMessageComposer()
    
    public init(questionLoader: QuestionLoader) {
        self.quizQuestionLoader = MainQueueDispatchDecorator(decoratee: questionLoader)
    }
    
    public func quizRootViewController() -> QuizRootViewController {
        let controller = makeQuizViewController()
        controller.quizHeaderController = headerComposer.header()
        controller.quizAnswerListController = listComposer.answerListController()
        controller.quizFooterController = footerComposer.footer()
        
        return controller
    }
    
    private func makeQuizViewController() -> QuizRootViewController {
        let bundle = Bundle(for: QuizRootViewController.self)
        let storyboard = UIStoryboard(name: "QuizRoot", bundle: bundle)
        let quizController = storyboard.instantiateInitialViewController() as! QuizRootViewController
        quizController.delegate = self
        
        return quizController
    }
    
    private func startGameEngine(_ questionItem: QuestionItem) {
        let quizGameEngine = QuizGameEngine(counter: self.counter, correctAnswers: questionItem.answer)
        self.quizGameEngine = quizGameEngine
        self.quizGameEngine?.delegate = WeakRefVirtualProxy(self)
        self.headerComposer.quizGameEngine = quizGameEngine
        self.footerComposer.quizGameEngine = quizGameEngine
        
        self.counter.delegate = WeakRefVirtualProxy(quizGameEngine)
    }
}

extension QuizUIComposer: QuizRootViewControllerDelegate {
    public func loadGame() {
        QuizLoadingComposer.showLoading()
                
        quizQuestionLoader.load { [weak self] result in
            switch result {
            case let .success(questions):
                guard let questionItem = questions.first else { return }
                                
                self?.headerComposer.headerPresenter?.didFinishLoadGame(with: questionItem)
                self?.footerComposer.presenter?.didFinishLoadGame(with: questionItem)
                
                self?.startGameEngine(questionItem)
                
                QuizLoadingComposer.hideLoading()
                
            case let .failure(error):
                QuizLoadingComposer.hideLoading()
                self?.messageComposer.showLoadingError(error)
            }
        }
    }
}

extension QuizUIComposer: QuizGameDelegate {
    public func gameStatus(_ gameStatus: GameStatus) {
        if gameStatus.isGameFinished {
            messageComposer.showFinishedGame(gameStatus)
        } else {
            headerComposer.headerPresenter?.didUpdateGameStatus(gameStatus)
            listComposer.updateList(gameStatus)
            footerComposer.presenter?.didUpdateGameStatus(gameStatus)
        }
    }
}