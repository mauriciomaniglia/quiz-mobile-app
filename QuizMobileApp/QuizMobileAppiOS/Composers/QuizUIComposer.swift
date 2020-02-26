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
    
    static func quizComposedWith(questionLoader: QuestionLoader) -> QuizViewController {
        let presentationAdapter = QuizLoaderPresentationAdapter(quizQuestionLoader:
            MainQueueDispatchDecorator(decoratee: questionLoader))
        
        let quizController = makeQuizViewController(delegate: presentationAdapter)
        let quizHeaderController = makeQuizHeaderViewController(delegate: presentationAdapter)
        let quizFooterController = makeQuizFooterViewController(delegate: presentationAdapter)
        
        presentationAdapter.presenter = QuizPresenter(
            loadingView: WeakRefVirtualProxy(quizController),            
            answerView: WeakRefVirtualProxy(quizController),
            errorView: WeakRefVirtualProxy(quizController),            
            resultView: WeakRefVirtualProxy(quizController))
        
        presentationAdapter.headerPresenter = QuizHeaderPresenter(quizHeader: quizHeaderController)
        presentationAdapter.footerPresenter = QuizFooterPresenter(quizFooter: quizFooterController)
        
        quizController.quizHeaderController = quizHeaderController
        quizController.quizFooterController = quizFooterController
        
        return quizController
    }
    
    private static func makeQuizViewController(delegate: QuizViewControllerDelegate) -> QuizViewController {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let quizController = storyboard.instantiateInitialViewController() as! QuizViewController
        quizController.delegate = delegate
        
        return quizController
    }
    
    private static func makeQuizHeaderViewController(delegate: QuizHeaderViewControllerDelegate) -> QuizHeaderViewController {
        let bundle = Bundle(for: QuizViewController.self)
        let headerStoryboard = UIStoryboard(name: "QuizHeader", bundle: bundle)
        let quizHeaderController = headerStoryboard.instantiateInitialViewController() as! QuizHeaderViewController
        quizHeaderController.delegate = delegate
        
        return quizHeaderController
    }
    
    private static func makeQuizFooterViewController(delegate: QuizFooterViewControllerDelegate) -> QuizFooterViewController {
        let bundle = Bundle(for: QuizFooterViewController.self)
        let footerStoryboard = UIStoryboard(name: "QuizFooter", bundle: bundle)
        let quizFooterController = footerStoryboard.instantiateInitialViewController() as! QuizFooterViewController
        quizFooterController.delegate = delegate
        
        return quizFooterController
    }
}
