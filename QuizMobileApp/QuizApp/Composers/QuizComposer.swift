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

public final class QuizComposer {
    private let quizQuestionLoader: QuestionLoader
    private var quizGameEngine: QuizGameEngine?
    private var counter = QuizGameTimer(withSeconds: 300)    
    private let messageComposer = QuizMessageComposer()
    private var isPlaying = false

    var headerPresenter: QuizHeaderPresenter?
    var listPresenter: QuizAnswerListPresenter?
    var footerPresenter: QuizFooterPresenter?
    
    public init(questionLoader: QuestionLoader) {
        self.quizQuestionLoader = MainQueueDispatchDecorator(decoratee: questionLoader)
    }
    
    public func quizRootViewController() -> QuizRootViewController {
        let controller = makeQuizViewController()
        controller.quizHeaderController = header()
        controller.quizAnswerListController = answerListController()
        controller.quizFooterController = footer()
        
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
        self.counter.delegate = WeakRefVirtualProxy(quizGameEngine)
    }

    func header() -> QuizHeaderViewController {
        let controller = makeQuizHeaderViewController()
        headerPresenter = QuizHeaderPresenter(quizHeader: WeakRefVirtualProxy(controller))

        return controller
    }

    private func makeQuizHeaderViewController() -> QuizHeaderViewController {
        let bundle = Bundle(for: QuizRootViewController.self)
        let headerStoryboard = UIStoryboard(name: "QuizHeader", bundle: bundle)
        let quizHeaderController = headerStoryboard.instantiateInitialViewController() as! QuizHeaderViewController
        quizHeaderController.delegate = self

        return quizHeaderController
    }

    func answerListController() -> QuizAnswerListViewController {
        let controller = makeQuizAnswerListViewController()
        listPresenter = QuizAnswerListPresenter(answerList: controller)
        return controller
    }

    private func makeQuizAnswerListViewController() -> QuizAnswerListViewController {
        let bundle = Bundle(for: QuizAnswerListViewController.self)
        let answerListStoryboard = UIStoryboard(name: "QuizAnswerList", bundle: bundle)
        let quizAnswerListController = answerListStoryboard.instantiateInitialViewController() as! QuizAnswerListViewController

        return quizAnswerListController
    }

    func footer() -> QuizFooterViewController {
        let controller = makeQuizFooterViewController()
        footerPresenter = QuizFooterPresenter(quizFooter: WeakRefVirtualProxy(controller))

        return controller
    }

    private func makeQuizFooterViewController() -> QuizFooterViewController {
        let bundle = Bundle(for: QuizFooterViewController.self)
        let footerStoryboard = UIStoryboard(name: "QuizFooter", bundle: bundle)
        let quizFooterController = footerStoryboard.instantiateInitialViewController() as! QuizFooterViewController
        quizFooterController.delegate = self

        return quizFooterController
    }
}

extension QuizComposer: QuizHeaderViewControllerDelegate {
    public func didTapNewAnswer(_ answer: String) {
        quizGameEngine?.addAnswer(answer)
    }
}

extension QuizComposer: QuizFooterViewControllerDelegate {
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

extension QuizComposer: QuizRootViewControllerDelegate {
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
}

extension QuizComposer: QuizGameDelegate {
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
