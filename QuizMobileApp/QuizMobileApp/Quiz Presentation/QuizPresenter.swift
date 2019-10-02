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
        errorView.display(.noError)
        loadingView.display(QuizLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadGame(with question: QuestionItem) {
        questionView.display(QuizQuestionViewModel(question: question.question))
        answerCountView.display(QuizAnswerCountViewModel(answerCount: "00/\(question.answer.count)"))
        statusView.display(QuizStatusViewModel(status: "start"))
        loadingView.display(QuizLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadGame(with error: Error) {
        errorView.display(.error(message: "Error message"))
        loadingView.display(QuizLoadingViewModel(isLoading: false))
    }
    
    public func didStartGame() {
        statusView.display(QuizStatusViewModel(status: "reset"))
    }
    
    public func didRestartGame() {
        answerView.display(QuizAnswerViewModel(answer: []))
        answerCountView.display(QuizAnswerCountViewModel(answerCount: "00/50"))
        statusView.display(QuizStatusViewModel(status: "start"))
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
    
    public func didFinishGame() {
        resultView.display(QuizResultViewModel(title: "Title", message: "message", retry: "try again"))
    }
}
