//
//  Counter.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol CounterDelegate {
    func counterSeconds(_ seconds: Int)
    func counterReseted(_ seconds: Int)
    func counterStopped(_ seconds: Int)
}

public protocol Counter {
    func start()
    func reset()
    func stop()
}
