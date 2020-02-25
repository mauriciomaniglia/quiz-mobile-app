//
//  QuizHeaderPresenter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 25/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol QuizHeader {
    func display(_ presentableModel: QuizHeaderPresentableModel)
}

public final class QuizHeaderPresenter {
    private let quizHeader: QuizHeader
    
    public init(quizHeader: QuizHeader) {
        self.quizHeader = quizHeader
    }
    
    public func didFinishLoadGame(with question: QuestionItem) {
        quizHeader.display(QuizHeaderPresentableModel(gameStarted: false, question: question.question))
    }
}
