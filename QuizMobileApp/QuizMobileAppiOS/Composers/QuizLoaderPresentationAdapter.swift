//
//  QuizLoaderPresentationAdapter.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

final class QuizLoaderPresentationAdapter: QuizRootViewControllerDelegate, QuizHeaderViewControllerDelegate, QuizFooterViewControllerDelegate, QuizMessage, QuizGameDelegate {
    
    private let quizQuestionLoader: QuestionLoader
    private var quizGameEngine: QuizGameEngine?
    private var counter: QuizGameTimer
    private var isPlaying = false
    private var quizLoading: QuizLoadingViewController
    private lazy var rootViewController: UIViewController? = {
        return UIApplication.shared.keyWindow!.rootViewController
    }()
        
    var headerPresenter: QuizHeaderPresenter?
    var answerListPresenter: QuizAnswerListPresenter?
    var footerPresenter: QuizFooterPresenter?
    var messagePresenter: QuizMessagePresenter?
    
    init(quizQuestionLoader: QuestionLoader, counter: QuizGameTimer, quizLoading: QuizLoadingViewController) {
        self.quizQuestionLoader = quizQuestionLoader
        self.counter = counter
        self.quizLoading = quizLoading
    }
    
    func loadGame() {        
        rootViewController?.present(quizLoading, animated: false)
                
        quizQuestionLoader.load { result in
            switch result {
            case let .success(questions):
                guard let questionItem = questions.first else { return }
                                
                self.headerPresenter?.didFinishLoadGame(with: questionItem)
                self.footerPresenter?.didFinishLoadGame(with: questionItem)
                self.quizGameEngine = QuizGameEngine(counter: self.counter, correctAnswers: questionItem.answer)
                self.quizGameEngine?.delegate = self
                self.counter.delegate = self.quizGameEngine
                self.rootViewController?.dismiss(animated: false, completion: nil)
                
            case let .failure(error):
                self.rootViewController?.dismiss(animated: false, completion: nil)
                self.messagePresenter?.didFinishLoadGame(with: error)
            }
        }
    }
    
    func didTapNewAnswer(_ answer: String) {
        quizGameEngine?.addAnswer(answer)
    }
    
    func didClickStatusButton() {
        if isPlaying {
            isPlaying = false
            quizGameEngine?.reset()
        } else {
            isPlaying = true
            quizGameEngine?.start()
        }
    }
    
    public func gameStatus(_ gameStatus: GameStatus) {
        if gameStatus.isGameFinished {
            messagePresenter?.didFinishGame(gameStatus)
        } else {
            headerPresenter?.didUpdateGameStatus(gameStatus)
            answerListPresenter?.didUpdateGameStatus(gameStatus)
            footerPresenter?.didUpdateGameStatus(gameStatus)
        }
    }
                    
    func displayErrorMessage(_ presentableModel: QuizMessagePresentableModel) {
        let retryButton = UIAlertAction(title: presentableModel.retry, style: .default, handler: { _ in
            self.rootViewController?.dismiss(animated: false, completion: nil)
            self.loadGame()
        })
        alertWithTitle(presentableModel.message, message: nil, action: retryButton)
    }
    
    func displayMessage(_ presentableModel: QuizMessagePresentableModel) {
        let retryButton = UIAlertAction(title: presentableModel.retry, style: .default, handler: { _ in self.didClickStatusButton() })
        alertWithTitle(presentableModel.title, message: presentableModel.message, action: retryButton)
    }
    
    private func alertWithTitle(_ title: String?, message: String?, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        rootViewController?.present(alert, animated: true)
    }
}
