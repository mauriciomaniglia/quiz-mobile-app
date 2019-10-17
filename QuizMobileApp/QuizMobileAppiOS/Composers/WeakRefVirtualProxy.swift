//
//  WeakRefVirtualProxy.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 03/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation
import QuizMobileApp

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: QuizAnswerView where T: QuizAnswerView {
    func display(_ viewModel: QuizAnswerViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizLoadingView where T: QuizLoadingView {
    func display(_ viewModel: QuizLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizErrorView where T: QuizErrorView {
    func display(_ viewModel: QuizErrorViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizStatusView where T: QuizStatusView {
    func display(_ viewModel: QuizStatusViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizQuestionView where T: QuizQuestionView {
    func display(_ viewModel: QuizQuestionViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizCounterView where T: QuizCounterView {
    func display(_ viewModel: QuizCounterViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizAnswerCountView where T: QuizAnswerCountView {
    func display(_ viewModel: QuizAnswerCountViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizResultView where T: QuizResultView {
    func display(_ viewModel: QuizResultViewModel) {
        object?.display(viewModel)
    }
}
