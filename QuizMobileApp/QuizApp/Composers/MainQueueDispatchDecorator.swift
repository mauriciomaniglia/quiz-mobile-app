//
//  MainQueueDispatchDecorator.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation
import QuizMobileApp

final class MainQueueDispatchDecorator<T> {
    private let decoratee: T
    
    init(decoratee: T) {
        self.decoratee = decoratee
    }
    
    func dispatch(completion: @escaping () -> Void) {
        guard Thread.isMainThread else {
            return DispatchQueue.main.async(execute: completion)
        }
        
        completion()
    }
}

extension MainQueueDispatchDecorator: QuestionLoader where T == QuestionLoader {
    func load(completion: @escaping (QuestionLoaderResult) -> Void) {
        decoratee.load { [weak self] result in
            self?.dispatch { completion(result) }
        }
    }
}
