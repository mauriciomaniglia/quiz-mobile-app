//
//  QuizLoaderPresentationAdapter.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

final class QuizLoaderPresentationAdapter: QuizRootViewControllerDelegate, QuizGameDelegate {
    
    private let quizQuestionLoader: QuestionLoader
    private var quizGameEngine: QuizGameEngine?
    private var counter: QuizGameTimer
    private lazy var rootViewController: UIViewController? = {
        return UIApplication.shared.keyWindow!.rootViewController
    }()
            
    var headerComposer: QuizHeaderComposer?
    var listComposer: QuizAnswerListComposer?
    var footerComposer: QuizFooterComposer?
    private let messageComposer: QuizMessageComposer
    
    init(quizQuestionLoader: QuestionLoader, counter: QuizGameTimer) {
        self.quizQuestionLoader = quizQuestionLoader
        self.counter = counter
        self.messageComposer = QuizMessageComposer()
        self.messageComposer.loadGame = { self.loadGame() }
        self.messageComposer.restartGame = { self.footerComposer?.didClickStatusButton() }
    }
    
    func loadGame() {
        QuizLoadingComposer.showLoading()
                
        quizQuestionLoader.load { result in
            switch result {
            case let .success(questions):
                guard let questionItem = questions.first else { return }
                                
                self.headerComposer?.headerPresenter?.didFinishLoadGame(with: questionItem)
                self.footerComposer?.presenter?.didFinishLoadGame(with: questionItem)
                
                let quizGameEngine = QuizGameEngine(counter: self.counter, correctAnswers: questionItem.answer)
                self.quizGameEngine = quizGameEngine
                self.quizGameEngine?.delegate = WeakRefVirtualProxy(self)
                self.headerComposer?.quizGameEngine = quizGameEngine
                self.footerComposer?.quizGameEngine = quizGameEngine
                
                self.counter.delegate = WeakRefVirtualProxy(quizGameEngine)
                QuizLoadingComposer.hideLoading()
                
            case let .failure(error):                
                QuizLoadingComposer.hideLoading()
                self.messageComposer.showLoadingError(error)
            }
        }
    }
    
    public func gameStatus(_ gameStatus: GameStatus) {
        if gameStatus.isGameFinished {
            messageComposer.showFinishedGame(gameStatus)
        } else {
            headerComposer?.headerPresenter?.didUpdateGameStatus(gameStatus)
            listComposer?.updateList(gameStatus)
            footerComposer?.presenter?.didUpdateGameStatus(gameStatus)
        }
    }                        
}
