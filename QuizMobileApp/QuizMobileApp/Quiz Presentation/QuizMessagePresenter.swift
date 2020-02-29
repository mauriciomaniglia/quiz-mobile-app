//
//  QuizMessagePresenter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 28/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol QuizMessage {
    func displayMessage(_ presentableModel: QuizMessagePresentableModel)
    func displayErrorMessage(_ presentableModel: QuizMessagePresentableModel)
}

public final class QuizMessagePresenter {
    private let messageView: QuizMessage
    
    public init(messageView: QuizMessage) {
        self.messageView = messageView
    }
    
    public func didFinishLoadGame(with error: Error) {
        messageView.displayErrorMessage(.error(message: LocalizedStrings.errorMessageText, retry: LocalizedStrings.tryAgainTitleText))
    }
    
    public func didFinishGame(_ gameResult: FinalResult) {
        if gameResult.scoreAll {
            messageView.displayMessage(QuizMessagePresentableModel(title: LocalizedStrings.congratulationsTitleText,
                                                                   message: LocalizedStrings.congratulationsMessageText,
                                                                   retry: LocalizedStrings.playAgainTitleText))
        } else {
            let message = String(format: LocalizedStrings.timeFinishedMessageText, gameResult.savedAnswersCorrect, gameResult.correctAnswersTotal)
            messageView.displayMessage(QuizMessagePresentableModel(title: LocalizedStrings.timeFinishedTitleText,
                                                                   message: message,
                                                                   retry: LocalizedStrings.tryAgainTitleText))
        }
    }
}
