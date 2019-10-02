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
        let presentationAdapter = FeedLoaderPresentationAdapter(quizQuestionLoader:
            MainQueueDispatchDecorator(decoratee: questionLoader))
        
        let quizController = makeQuizViewController(
        delegate: presentationAdapter)
        
        presentationAdapter.presenter = QuizPresenter(
            loadingView: quizController,
            questionView: quizController,
            answerView: quizController,
            errorView: quizController,
            statusView: quizController,
            counterView: quizController,
            answerCountView: quizController,
            resultView: quizController)
        
        return quizController
    }
    
    private static func makeQuizViewController(delegate: QuizViewControllerDelegate) -> QuizViewController {
        let bundle = Bundle(for: QuizViewController.self)
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let quizController = storyboard.instantiateInitialViewController() as! QuizViewController
        quizController.delegate = delegate
        return quizController
    }
}
