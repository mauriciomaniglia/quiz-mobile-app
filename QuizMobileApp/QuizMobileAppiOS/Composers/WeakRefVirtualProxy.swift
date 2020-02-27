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

extension WeakRefVirtualProxy: QuizErrorView where T: QuizErrorView {
    func display(_ viewModel: QuizErrorPresentableModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: QuizResultView where T: QuizResultView {
    func display(_ viewModel: QuizResultPresentableModel) {
        object?.display(viewModel)
    }
}
