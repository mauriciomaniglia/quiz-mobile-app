//
//  QuizPresenter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol QuizAnswerView {
    func display(_ viewModel: QuizAnswerPresentableModel)
}

public protocol QuizLoadingView {
    func display(_ viewModel: QuizLoadingPresentableModel)
}

public protocol QuizErrorView {
    func display(_ viewModel: QuizErrorPresentableModel)
}

public protocol QuizStatusView {
    func display(_ viewModel: QuizStatusPresentableModel)
}

public protocol QuizCounterView {
    func display(_ viewModel: QuizCounterPresentableModel)
}

public protocol QuizAnswerCountView {
    func display(_ viewModel: QuizAnswerCountPresentableModel)
}

public protocol QuizResultView {
    func display(_ viewModel: QuizResultPresentableModel)
}

public final class QuizPresenter {
    private let loadingView: QuizLoadingView
    //private let questionView: QuizQuestionView
    private let answerView: QuizAnswerView
    private let errorView: QuizErrorView
    private let statusView: QuizStatusView
    private let counterView: QuizCounterView
    private let answerCountView: QuizAnswerCountView
    private let resultView: QuizResultView
    
    private var startStatus: String {
        return localizedString("QUIZ_START_STATUS", comment: "Title for the start game status")
    }
    private var resetStatus: String {
        return localizedString("QUIZ_RESET_STATUS", comment: "Title for the reset game status")
    }
    private var congratulationsTitle: String {
        return localizedString("QUIZ_CONGRATULATIONS_TITLE", comment: "Congratulations title for the game final result")
    }
    private var congratulationsMessage: String {
        return localizedString("QUIZ_CONGRATULATIONS_MESSAGE", comment: "Congratulations message for the game final result")
    }
    private var playAgainTitle: String {
        return localizedString("QUIZ_PLAY_AGAIN_TITLE", comment: "Title for play again message on game final result")
    }
    private var timeFinishedTitle: String {
        return localizedString("QUIZ_TIME_FINISHED_TITLE", comment: "Time finished title for the game final result")
    }
    private var timeFinishedMessage: String {
        return localizedString("QUIZ_TIME_FINISHED_MESSAGE", comment: "Time finished message for the game final result")
    }
    private var tryAgainTitle: String {
        return localizedString("QUIZ_TRY_AGAIN_TITLE", comment: "Title for try again message on game final result")
    }
    private var errorMessage: String {
        return localizedString("QUIZ_ERROR_MESSAGE", comment: "Message for connection error")
    }
    
    public init(loadingView: QuizLoadingView, answerView: QuizAnswerView, errorView: QuizErrorView, statusView: QuizStatusView, counterView: QuizCounterView, answerCountView: QuizAnswerCountView, resultView: QuizResultView) {
        self.loadingView = loadingView
        self.answerView = answerView
        self.errorView = errorView
        self.statusView = statusView
        self.counterView = counterView
        self.answerCountView = answerCountView
        self.resultView = resultView
    }
    
    public func didStartLoadGame() {        
        loadingView.display(QuizLoadingPresentableModel(isLoading: true))
    }
    
    public func didFinishLoadGame(with question: QuestionItem) {        
        answerCountView.display(QuizAnswerCountPresentableModel(answerCount: "00/\(question.answer.count)"))
        statusView.display(QuizStatusPresentableModel(isPlaying: true, status: startStatus))
        loadingView.display(QuizLoadingPresentableModel(isLoading: false))
    }
    
    public func didFinishLoadGame(with error: Error) {
        loadingView.display(QuizLoadingPresentableModel(isLoading: false))
        errorView.display(.error(message: errorMessage, retry: tryAgainTitle))
    }
    
    public func didStartGame() {
        statusView.display(QuizStatusPresentableModel(isPlaying: false, status: resetStatus))
    }
    
    public func didRestartGame(_ gameResult: FinalResult) {
        answerView.display(QuizAnswerPresentableModel(answer: []))
        answerCountView.display(QuizAnswerCountPresentableModel(answerCount: "00/\(gameResult.correctAnswersTotal)"))
        statusView.display(QuizStatusPresentableModel(isPlaying: true, status: startStatus))
        counterView.display(QuizCounterPresentableModel(seconds: "05:00"))
    }
    
    public func didAddNewAnswer(_ answers: AddAnswerResult) {
        answerView.display(QuizAnswerPresentableModel(answer: answers.savedAnswers))
        answerCountView.display(QuizAnswerCountPresentableModel(answerCount: "\(answers.savedAnswers.count)/\(answers.correctAnswersTotal)"))
    }
    
    public func didUpdateCounter(withSeconds seconds: Int) {
        let minutes = Int(seconds) / 60 % 60
        let seconds = Int(seconds) % 60
        let formatedValue = String(format:"%02i:%02i", minutes, seconds)
        counterView.display(QuizCounterPresentableModel(seconds: formatedValue))
    }
    
    public func didFinishGame(_ gameResult: FinalResult) {
        if gameResult.scoreAll {
            resultView.display(QuizResultPresentableModel(title: congratulationsTitle, message: congratulationsMessage, retry: playAgainTitle))
        } else {
            let message = String(format: timeFinishedMessage, gameResult.savedAnswersCorrect, gameResult.correctAnswersTotal)
            resultView.display(QuizResultPresentableModel(title: timeFinishedTitle, message: message, retry: tryAgainTitle))
        }
    }
    
    private func localizedString(_ key: String, comment: String, placeholders: String...) -> String {
        return NSLocalizedString(key,
                                 tableName: "Quiz",
                                 bundle: Bundle(for: QuizPresenter.self),
                                 comment: comment)
    }
}
