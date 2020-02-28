//
//  QuizUIComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

final class QuizUIComposer {
    private init() {}
    
    static func quizComposedWith(questionLoader: QuestionLoader) -> QuizRootViewController {
        let quizLoadingController = makeQuizLoadingViewController()
        
        let presentationAdapter = QuizLoaderPresentationAdapter(quizQuestionLoader:
            MainQueueDispatchDecorator(decoratee: questionLoader), quizLoading: quizLoadingController)
        
        let quizController = makeQuizViewController(delegate: presentationAdapter)
        let quizHeaderController = makeQuizHeaderViewController(delegate: presentationAdapter)
        let quizAnswerListController = makeQuizAnswerListViewController()
        let quizFooterController = makeQuizFooterViewController(delegate: presentationAdapter)
        
        presentationAdapter.headerPresenter = QuizHeaderPresenter(quizHeader: WeakRefVirtualProxy(quizHeaderController))
        presentationAdapter.answerListPresenter = QuizAnswerListPresenter(answerList: WeakRefVirtualProxy(quizAnswerListController))
        presentationAdapter.footerPresenter = QuizFooterPresenter(quizFooter: WeakRefVirtualProxy(quizFooterController))
        presentationAdapter.messagePresenter = QuizMessagePresenter(messageView: presentationAdapter)
        
        quizController.quizHeaderController = quizHeaderController
        quizController.quizAnswerListController = quizAnswerListController
        quizController.quizFooterController = quizFooterController
        
        return quizController
    }
    
    private static func makeQuizViewController(delegate: QuizRootViewControllerDelegate) -> QuizRootViewController {
        let bundle = Bundle(for: QuizRootViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let quizController = storyboard.instantiateInitialViewController() as! QuizRootViewController
        quizController.delegate = delegate
        
        return quizController
    }
    
    private static func makeQuizHeaderViewController(delegate: QuizHeaderViewControllerDelegate) -> QuizHeaderViewController {
        let bundle = Bundle(for: QuizRootViewController.self)
        let headerStoryboard = UIStoryboard(name: "QuizHeader", bundle: bundle)
        let quizHeaderController = headerStoryboard.instantiateInitialViewController() as! QuizHeaderViewController
        quizHeaderController.delegate = delegate
        
        return quizHeaderController
    }
    
    private static func makeQuizAnswerListViewController() -> QuizAnswerListViewController {
        let bundle = Bundle(for: QuizAnswerListViewController.self)
        let answerListStoryboard = UIStoryboard(name: "QuizAnswerList", bundle: bundle)
        let quizAnswerListController = answerListStoryboard.instantiateInitialViewController() as! QuizAnswerListViewController
        
        return quizAnswerListController
    }
    
    private static func makeQuizFooterViewController(delegate: QuizFooterViewControllerDelegate) -> QuizFooterViewController {
        let bundle = Bundle(for: QuizFooterViewController.self)
        let footerStoryboard = UIStoryboard(name: "QuizFooter", bundle: bundle)
        let quizFooterController = footerStoryboard.instantiateInitialViewController() as! QuizFooterViewController
        quizFooterController.delegate = delegate
        
        return quizFooterController
    }
    
    private static func makeQuizLoadingViewController() -> QuizLoadingViewController {
        let storyboard = UIStoryboard(name: "QuizLoading", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: "QuizLoadingViewController") as! QuizLoadingViewController
        return loadingViewController
    }
}
