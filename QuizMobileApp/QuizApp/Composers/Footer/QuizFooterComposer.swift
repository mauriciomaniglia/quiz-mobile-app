//
//  QuizFooterComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 11/04/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

final class QuizFooterComposer {
    var quizGameEngine: QuizGameEngine?
    var presenter: QuizFooterPresenter?
    
    private var isPlaying = false
    
    func footer() -> QuizFooterViewController {
        let controller = makeQuizFooterViewController()
        presenter = QuizFooterPresenter(quizFooter: WeakRefVirtualProxy(controller))
        
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

extension QuizFooterComposer: QuizFooterViewControllerDelegate {
    func didClickStatusButton() {
        if isPlaying {
            isPlaying = false
            quizGameEngine?.reset()
        } else {
            isPlaying = true
            quizGameEngine?.start()
        }
    }
}
