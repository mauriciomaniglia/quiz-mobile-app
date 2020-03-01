//
//  QuizGame.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 03/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public protocol QuizGame {
    func start()
    func reset()
    func addAnswer(_ answer: String)
}

public protocol QuizGameDelegate {
    func gameStatus(_ gameStatus: GameStatus)
}

public struct GameStatus {
    public var isGameStarted: Bool
    public var isGameFinished: Bool
    public var currentSeconds: Int
    public var correctAnswers: [String]
    public var userAnswers: [String]
    public var userHitAllAnswers: Bool {
        return userAnswers.count == correctAnswers.count
    }
}
