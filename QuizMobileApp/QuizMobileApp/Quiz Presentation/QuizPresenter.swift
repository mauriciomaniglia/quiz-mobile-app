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

public final class QuizPresenter {
    
    public func didLoadGame() {
        
    }
    
    public func didStartGame() {
        
    }
    
    public func didRestartGame() {
        
    }
    
    public func didAddNewAnswer() {
        
    }
}
