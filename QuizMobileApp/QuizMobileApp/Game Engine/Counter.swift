//
//  Counter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public enum CounterResult: Equatable {
    case start
    case currentSecond(Int)
    case reset
}

public protocol Counter {
    func start(completion: @escaping (CounterResult) -> Void)
    func reset()
}
