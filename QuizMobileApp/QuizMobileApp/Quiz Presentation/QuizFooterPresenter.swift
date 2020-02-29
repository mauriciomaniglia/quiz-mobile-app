//
//  QuizFooterPresenter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 25/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol QuizFooter {
    func display(_ presentableModel: QuizFooterPresentableModel)
}

final public class QuizFooterPresenter {
    private let quizFooter: QuizFooter
    
    public init(quizFooter: QuizFooter) {
        self.quizFooter = quizFooter
    }
    
    public func didFinishLoadGame(with question: QuestionItem) {
        let initialAnswerCount = "00/\(question.answer.count)"
        quizFooter.display(QuizFooterPresentableModel(status: LocalizedStrings.startGameText, seconds: nil, answerCount: initialAnswerCount))
    }
    
    public func didStartGame() {
        quizFooter.display(QuizFooterPresentableModel(status: LocalizedStrings.resetGameText, seconds: nil, answerCount: nil))
    }
    
    public func didRestartGame(_ gameResult: FinalResult) {
        let answerCount = "00/\(gameResult.correctAnswersTotal)"
        quizFooter.display(QuizFooterPresentableModel(status: LocalizedStrings.startGameText, seconds: "05:00", answerCount: answerCount))
    }
    
    public func didAddNewAnswer(_ answers: AddAnswerResult) {
        let answerCount = "\(answers.savedAnswers.count)/\(answers.correctAnswersTotal)"
        quizFooter.display(QuizFooterPresentableModel(status: LocalizedStrings.resetGameText, seconds: nil, answerCount: answerCount))
    }
    
    public func didUpdateCounter(withSeconds seconds: Int) {
        let minutes = Int(seconds) / 60 % 60
        let seconds = Int(seconds) % 60
        let formatedValue = String(format:"%02i:%02i", minutes, seconds)
        quizFooter.display(QuizFooterPresentableModel(status: nil, seconds: formatedValue, answerCount: nil))
    }
}
