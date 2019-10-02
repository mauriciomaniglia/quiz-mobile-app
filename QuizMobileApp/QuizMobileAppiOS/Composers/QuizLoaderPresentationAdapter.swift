//
//  QuizLoaderPresentationAdapter.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import QuizMobileApp

final class FeedLoaderPresentationAdapter: QuizViewControllerDelegate {
    private let quizQuestionLoader: QuestionLoader
    var presenter: QuizPresenter?
    
    init(quizQuestionLoader: QuestionLoader) {
        self.quizQuestionLoader = quizQuestionLoader
    }
    
    func didRequestLoading() {
        presenter?.didStartLoadGame()
        
        quizQuestionLoader.load { result in
            switch result {
            case let .success(questions):
                self.presenter?.didFinishLoadGame(with: questions.first!)                
            case let .failure(error):
                self.presenter?.didFinishLoadGame(with: error)
            }
        }
    }
    
    func didTapNewAnswer(_ answer: String) {
        
    }
    
    func didClickStatusButton() {
        
    }
}
