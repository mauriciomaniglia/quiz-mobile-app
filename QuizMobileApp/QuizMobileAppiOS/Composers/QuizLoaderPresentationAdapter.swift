//
//  QuizLoaderPresentationAdapter.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import QuizMobileApp

final class QuizLoaderPresentationAdapter: QuizViewControllerDelegate, QuizHeaderViewControllerDelegate, QuizFooterViewControllerDelegate {
    private let quizQuestionLoader: QuestionLoader
    private var quizGameEngine: QuizGameEngine?
    private var counter = QuizGameTimer(withSeconds: 300)
    private var isPlaying = false
    var presenter: QuizPresenter?
    var headerPresenter: QuizHeaderPresenter?
    var footerPresenter: QuizFooterPresenter?
    
    init(quizQuestionLoader: QuestionLoader) {
        self.quizQuestionLoader = quizQuestionLoader
    }
    
    func didRequestLoading() {
        presenter?.didStartLoadGame()        
        quizQuestionLoader.load { result in
            switch result {
            case let .success(questions):
                guard let questionItem = questions.first else { return }
                
                self.presenter?.didFinishLoadGame(with: questionItem)
                self.headerPresenter?.didFinishLoadGame(with: questionItem)
                self.footerPresenter?.didFinishLoadGame(with: questionItem)
                self.quizGameEngine = QuizGameEngine(counter: self.counter, correctAnswers: questionItem.answer)
                
            case let .failure(error):
                self.presenter?.didFinishLoadGame(with: error)
            }
        }
    }
    
    func didTapNewAnswer(_ answer: String) {
        quizGameEngine?.addAnswer(answer) { result in
            self.presenter?.didAddNewAnswer(result)
            self.footerPresenter?.didAddNewAnswer(result)
        }
    }
    
    func didClickStatusButton() {
        if isPlaying {
            isPlaying = false
            self.quizGameEngine?.restartGame { result in
                self.presenter?.didRestartGame(result)                
                self.footerPresenter?.didRestartGame(result)
            }
        } else {
            isPlaying = true
            self.quizGameEngine?.startGame { result in
                switch result {
                    case .gameStarted:
                        self.headerPresenter?.didStartGame()
                        self.footerPresenter?.didStartGame()
                    case let .updateSecond(seconds): self.footerPresenter?.didUpdateCounter(withSeconds: seconds)
                    case let .gameFinished(result): self.presenter?.didFinishGame(result)
                }
            }
        }
    }
}
