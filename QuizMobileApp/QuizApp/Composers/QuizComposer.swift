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
    private let adapter: QuizAdapter
    
    public init(questionLoader: QuestionLoader) {
        self.quizQuestionLoader = MainQueueDispatchDecorator(decoratee: questionLoader)
        self.adapter = QuizAdapter(questionLoader: self.quizQuestionLoader)
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
        quizController.delegate = adapter
        
        return quizController
    }

    func header() -> QuizHeaderViewController {
        let controller = makeQuizHeaderViewController()
        adapter.headerPresenter = QuizHeaderPresenter(quizHeader: WeakRefVirtualProxy(controller))

        return controller
    }

    private func makeQuizHeaderViewController() -> QuizHeaderViewController {
        let bundle = Bundle(for: QuizRootViewController.self)
        let headerStoryboard = UIStoryboard(name: "QuizHeader", bundle: bundle)
        let quizHeaderController = headerStoryboard.instantiateInitialViewController() as! QuizHeaderViewController
        quizHeaderController.delegate = adapter

        return quizHeaderController
    }

    func answerListController() -> QuizAnswerListViewController {
        let controller = makeQuizAnswerListViewController()
        adapter.listPresenter = QuizAnswerListPresenter(answerList: controller)
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
        adapter.footerPresenter = QuizFooterPresenter(quizFooter: WeakRefVirtualProxy(controller))

        return controller
    }

    private func makeQuizFooterViewController() -> QuizFooterViewController {
        let bundle = Bundle(for: QuizFooterViewController.self)
        let footerStoryboard = UIStoryboard(name: "QuizFooter", bundle: bundle)
        let quizFooterController = footerStoryboard.instantiateInitialViewController() as! QuizFooterViewController
        quizFooterController.delegate = adapter

        return quizFooterController
    }
}
