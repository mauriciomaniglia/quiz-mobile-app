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
        let initialAnswerCount = "0/\(question.answer.count)"
        quizFooter.display(QuizFooterPresentableModel(status: LocalizedStrings.startGameText, seconds: nil, answerCount: initialAnswerCount))
    }
    
    public func didUpdateGameStatus(_ gameStatus: GameStatus) {
        let minutes = Int(gameStatus.currentSeconds) / 60 % 60
        let seconds = Int(gameStatus.currentSeconds) % 60
        let formatedSeconds = String(format:"%02i:%02i", minutes, seconds)
        
        let answerCount = "\(gameStatus.userAnswers.count)/\(gameStatus.correctAnswers.count)"
        let gameStatusText = gameStatus.isGameStarted ? LocalizedStrings.resetGameText : LocalizedStrings.startGameText
        
        quizFooter.display(QuizFooterPresentableModel(status: gameStatusText,
                                                      seconds: formatedSeconds,
                                                      answerCount: answerCount))                        
    }
}
