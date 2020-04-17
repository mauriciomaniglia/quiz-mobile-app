//
//  QuizAnswerListComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 16/04/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

final class QuizAnswerListComposer {
    private var presenter: QuizAnswerListPresenter?
    
    func updateList(_ gameStatus: GameStatus) {
        presenter?.didUpdateGameStatus(gameStatus)
    }
    
    func answerListController() -> QuizAnswerListViewController {
        let controller = makeQuizAnswerListViewController()
        presenter = QuizAnswerListPresenter(answerList: controller)
        return controller
    }
    
    private func makeQuizAnswerListViewController() -> QuizAnswerListViewController {
        let bundle = Bundle(for: QuizAnswerListViewController.self)
        let answerListStoryboard = UIStoryboard(name: "QuizAnswerList", bundle: bundle)
        let quizAnswerListController = answerListStoryboard.instantiateInitialViewController() as! QuizAnswerListViewController
        
        return quizAnswerListController
    }
}
