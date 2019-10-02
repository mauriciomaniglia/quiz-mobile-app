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
    private let counterView: QuizCounterView
    private let answerCountView: QuizAnswerCountView
    private let resultView: QuizResultView
    
    public init(loadingView: QuizLoadingView, questionView: QuizQuestionView, answerView: QuizAnswerView, errorView: QuizErrorView, counterView: QuizCounterView, answerCountView: QuizAnswerCountView, resultView: QuizResultView) {
        self.loadingView = loadingView
        self.questionView = questionView
        self.answerView = answerView
        self.errorView = errorView
        self.counterView = counterView
        self.answerCountView = answerCountView
        self.resultView = resultView
    }
    
    public func didLoadGame() {
        
    }
    
    public func didStartGame() {
        
    }
    
    public func didRestartGame() {
        
    }
    
    public func didAddNewAnswer() {
        
    }
}
