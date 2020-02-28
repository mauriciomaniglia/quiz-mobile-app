//
//  QuizAnswerListPresenter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 27/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol QuizAnswerList {
    func display(_ presentableModel: QuizAnswerListPresentableModel)
}

public final class QuizAnswerListPresenter {
    private let answerList: QuizAnswerList
    
    public init(answerList: QuizAnswerList) {
        self.answerList = answerList
    }
    
    public func didRestartGame(_ gameResult: FinalResult) {
        answerList.display(QuizAnswerListPresentableModel(answer: []))
    }
    
    public func didAddNewAnswer(_ answers: AddAnswerResult) {
        answerList.display(QuizAnswerListPresentableModel(answer: answers.savedAnswers))
    }
}
