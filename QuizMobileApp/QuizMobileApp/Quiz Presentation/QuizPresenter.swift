//
//  QuizPresenter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol QuizAnswerView {
    func display(_ viewModel: QuizAnswerViewModel)
}

public protocol QuizLoadingView {
    func display(_ viewModel: QuizLoadingViewModel)
}

public protocol QuizErrorView {
    func display(_ viewModel: QuizErrorViewModel)
}

public protocol QuizStatusView {
    func display(_ viewModel: QuizStatusViewModel)
}

public protocol QuizQuestionView {
    func display(_ viewModel: QuizQuestionViewModel)
}

public protocol QuizCounterView {
    func display(_ viewModel: QuizCounterViewModel)
}

public protocol QuizAnswerCountView {
    func display(_ viewModel: QuizAnswerCountViewModel)
}

public protocol QuizResultView {
    func display(_ viewModel: QuizResultViewModel)
}

public final class QuizPresenter {
    private let loadingView: QuizLoadingView
    private let questionView: QuizQuestionView
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
    
    public init(loadingView: QuizLoadingView, questionView: QuizQuestionView, answerView: QuizAnswerView, errorView: QuizErrorView, statusView: QuizStatusView, counterView: QuizCounterView, answerCountView: QuizAnswerCountView, resultView: QuizResultView) {
        self.loadingView = loadingView
        self.questionView = questionView
        self.answerView = answerView
        self.errorView = errorView
        self.statusView = statusView
        self.counterView = counterView
        self.answerCountView = answerCountView
        self.resultView = resultView
    }
    
    public func didStartLoadGame() {        
        loadingView.display(QuizLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadGame(with question: QuestionItem) {
        questionView.display(QuizQuestionViewModel(question: question.question))
        answerCountView.display(QuizAnswerCountViewModel(answerCount: "00/\(question.answer.count)"))
        statusView.display(QuizStatusViewModel(isPlaying: true, status: startStatus))
        loadingView.display(QuizLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadGame(with error: Error) {
        loadingView.display(QuizLoadingViewModel(isLoading: false))
        errorView.display(.error(message: errorMessage, retry: tryAgainTitle))
    }
    
    public func didStartGame() {
        statusView.display(QuizStatusViewModel(isPlaying: false, status: resetStatus))
    }
    
    public func didRestartGame() {
        answerView.display(QuizAnswerViewModel(answer: []))
        answerCountView.display(QuizAnswerCountViewModel(answerCount: "00/50"))
        statusView.display(QuizStatusViewModel(isPlaying: true, status: startStatus))
        counterView.display(QuizCounterViewModel(seconds: "05:00"))
    }
    
    public func didAddNewAnswer(_ answers: [String]) {
        answerView.display(QuizAnswerViewModel(answer: answers))
        answerCountView.display(QuizAnswerCountViewModel(answerCount: "\(answers.count)/50"))
    }
    
    public func didUpdateCounter(withSeconds seconds: Int) {
        let minutes = Int(seconds) / 60 % 60
        let seconds = Int(seconds) % 60
        let formatedValue = String(format:"%02i:%02i", minutes, seconds)
        counterView.display(QuizCounterViewModel(seconds: formatedValue))
    }
    
    public func didFinishGame(_ gameResult: GameResult) {
        if gameResult.scoreAll {
            resultView.display(QuizResultViewModel(title: congratulationsTitle, message: congratulationsMessage, retry: playAgainTitle))
        } else {
            let message = String(format: timeFinishedMessage, gameResult.savedAnswersCorrect, gameResult.correctAnswersTotal)
            resultView.display(QuizResultViewModel(title: timeFinishedTitle, message: message, retry: tryAgainTitle))
        }
    }
    
    private func localizedString(_ key: String, comment: String, placeholders: String...) -> String {
        return NSLocalizedString(key,
                                 tableName: "Quiz",
                                 bundle: Bundle(for: QuizPresenter.self),
                                 comment: comment)
    }
}
