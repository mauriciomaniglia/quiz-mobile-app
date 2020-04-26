//
//  QuizHeaderComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 11/04/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import Quiz
import QuiziOS

final class QuizHeaderComposer {
    var quizGameEngine: QuizGameEngine?
    var headerPresenter: QuizHeaderPresenter?
    
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
}

extension QuizHeaderComposer: QuizHeaderViewControllerDelegate {
    func didTapNewAnswer(_ answer: String) {
        quizGameEngine?.addAnswer(answer)
    }
}
