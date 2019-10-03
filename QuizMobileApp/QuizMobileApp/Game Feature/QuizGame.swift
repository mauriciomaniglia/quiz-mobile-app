//
//  QuizGame.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 03/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public enum QuizGameEngineResult: Equatable {
    case gameStarted
    case updateSecond(Int)
    case gameFinished(FinalResult)
}

public typealias AddAnswerResult = (savedAnswers: [String], correctAnswersTotal: Int)

public struct FinalResult: Equatable {
    public let scoreAll: Bool
    public let savedAnswersCorrect: Int
    public let correctAnswersTotal: Int
    
    public init(scoreAll: Bool, savedAnswersCorrect: Int, correctAnswersTotal: Int) {
        self.scoreAll = scoreAll
        self.savedAnswersCorrect = savedAnswersCorrect
        self.correctAnswersTotal = correctAnswersTotal
    }
}

public protocol QuizGame {
    func startGame(completion: @escaping (QuizGameEngineResult) -> Void)
    func addAnswer(_ answer: String, completion: @escaping (AddAnswerResult) -> Void)
    func restartGame(completion: @escaping (FinalResult) -> Void)
}
