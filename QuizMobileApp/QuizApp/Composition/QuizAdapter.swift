//
//  QuizAdapter.swift
//  QuizApp
//
//  Created by Mauricio Maniglia on 15/05/21.
//  Copyright © 2021 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Quiz
import QuiziOS

final class QuizAdapter {
    private var isPlaying = false
    private var counter = QuizGameTimer(withSeconds: 300)
    
    private var quizGameEngine: QuizGameEngine?
    private let quizQuestionLoader: QuestionLoader
    private let messageComposer = QuizMessageComposer()

    var headerPresenter: QuizHeaderPresenter?
    var listPresenter: QuizAnswerListPresenter?
    var footerPresenter: QuizFooterPresenter?

    public init(questionLoader: QuestionLoader) {
        self.quizQuestionLoader = MainQueueDispatchDecorator(decoratee: questionLoader)
    }
}

extension QuizAdapter: QuizHeaderViewControllerDelegate {
    public func didTapNewAnswer(_ answer: String) {
        quizGameEngine?.addAnswer(answer)
    }
}

extension QuizAdapter: QuizFooterViewControllerDelegate {
    public func didClickStatusButton() {
        if isPlaying {
            isPlaying = false
            quizGameEngine?.reset()
        } else {
            isPlaying = true
            quizGameEngine?.start()
        }
    }
}

extension QuizAdapter: QuizRootViewControllerDelegate {
    public func loadGame() {
        QuizLoadingComposer.showLoading()

        quizQuestionLoader.load { [weak self] result in
            switch result {
            case let .success(questions):
                guard let questionItem = questions.first else { return }

                self?.headerPresenter?.didFinishLoadGame(with: questionItem)
                self?.footerPresenter?.didFinishLoadGame(with: questionItem)
                self?.startGameEngine(questionItem)

                QuizLoadingComposer.hideLoading()

            case let .failure(error):
                QuizLoadingComposer.hideLoading()
                self?.messageComposer.showLoadingError(error)
            }
        }
    }

    private func startGameEngine(_ questionItem: QuestionItem) {
        let quizGameEngine = QuizGameEngine(counter: self.counter, correctAnswers: questionItem.answer)
        self.quizGameEngine = quizGameEngine
        self.quizGameEngine?.delegate = WeakRefVirtualProxy(self)
        self.counter.delegate = WeakRefVirtualProxy(quizGameEngine)
    }
}

extension QuizAdapter: QuizGameDelegate {
    public func gameStatus(_ gameStatus: GameStatus) {
        if gameStatus.isGameFinished {
            messageComposer.showFinishedGame(gameStatus)
        } else {
            headerPresenter?.didUpdateGameStatus(gameStatus)
            listPresenter?.didUpdateGameStatus(gameStatus)
            footerPresenter?.didUpdateGameStatus(gameStatus)
        }
    }
}
