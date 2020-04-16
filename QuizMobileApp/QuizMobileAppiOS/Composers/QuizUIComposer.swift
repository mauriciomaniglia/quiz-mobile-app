//
//  QuizUIComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

public final class QuizUIComposer {
    private init() {}
    
    public static func quizComposedWith(questionLoader: QuestionLoader) -> QuizRootViewController {
        let counter = QuizGameTimer(withSeconds: 300)
        let presentationAdapter = QuizLoaderPresentationAdapter(quizQuestionLoader:
            MainQueueDispatchDecorator(decoratee: questionLoader), counter: counter)        
        
        let quizController = makeQuizViewController(delegate: presentationAdapter)
        
        let headerComposer = QuizHeaderComposer()
        let footerComposer = QuizFooterComposer()        
        
        let quizHeaderController = headerComposer.header()
        let quizAnswerListController = makeQuizAnswerListViewController()
        let quizFooterController = footerComposer.footer()
        
        presentationAdapter.headerComposer = headerComposer
        presentationAdapter.answerListPresenter = QuizAnswerListPresenter(answerList: WeakRefVirtualProxy(quizAnswerListController))
        presentationAdapter.footerComposer = footerComposer        
        
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
    
    private static func makeQuizAnswerListViewController() -> QuizAnswerListViewController {
        let bundle = Bundle(for: QuizAnswerListViewController.self)
        let answerListStoryboard = UIStoryboard(name: "QuizAnswerList", bundle: bundle)
        let quizAnswerListController = answerListStoryboard.instantiateInitialViewController() as! QuizAnswerListViewController
        
        return quizAnswerListController
    }
}
