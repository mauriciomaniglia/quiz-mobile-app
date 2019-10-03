//
//  QuizGameEngine.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public struct GameResult: Equatable {
    
    public init(scoreAll: Bool, savedAnswersCorrect: Int, correctAnswersTotal: Int) {
        self.scoreAll = scoreAll
        self.savedAnswersCorrect = savedAnswersCorrect
        self.correctAnswersTotal = correctAnswersTotal
    }
    
    public let scoreAll: Bool
    public let savedAnswersCorrect: Int
    public let correctAnswersTotal: Int
}

public final class QuizGameEngine {
    private let counter: Counter
    private let correctAnswers: [String]
    private var savedAnswers = [String]()
    private var savedAnswersCorrect = 0
    
    public typealias AddAnswerResult = (savedAnswers: [String], correctAnswersTotal: Int)
    
    public enum QuizGameEngineResult: Equatable {
        case gameStarted
        case updateSecond(Int)
        case gameFinished(GameResult)
    }
    
    public init(counter: Counter, correctAnswers: [String]) {
        self.counter = counter
        self.correctAnswers = correctAnswers
    }
    
    public func startGame(completion: @escaping (QuizGameEngineResult) -> Void) {
        guard correctAnswers.count > 0 else { return }
        
        self.counter.start { [weak self] counterResult in
            guard self != nil else { return }
            
            switch counterResult {
            case .start:
                completion(.gameStarted)
            case let .currentSecond(second):
                completion(.updateSecond(second))
            case .reset: break
            case .stop:
                completion(.gameFinished(self!.gameResult()))
            }
        }
    }
    
    public func addAnswer(_ answer: String, completion: @escaping (AddAnswerResult) -> Void) {
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAnswer.isEmpty else { return }
        guard !savedAnswers.contains(trimmedAnswer) else { return }
        guard savedAnswers.count < correctAnswers.count else { return }
        
        if correctAnswers.contains(trimmedAnswer) {
            savedAnswersCorrect += 1
        }
        
        savedAnswers.append(trimmedAnswer)
        validateAnswers()
        
        completion((savedAnswers, correctAnswers.count))
    }
    
    public func restartGame(completion: @escaping ([String:Int]) -> Void) {
        counter.reset()
        savedAnswers = []
        completion(["correct_answers_count": correctAnswers.count])
    }
    
    private func validateAnswers() {
        if savedAnswers.count == correctAnswers.count {
            counter.stop()
        }
    }
    
    private func gameResult() -> GameResult {
        if savedAnswersCorrect == correctAnswers.count {
            return GameResult(scoreAll: true, savedAnswersCorrect: savedAnswersCorrect, correctAnswersTotal: correctAnswers.count)
        } else {
            return GameResult(scoreAll: false, savedAnswersCorrect: savedAnswersCorrect, correctAnswersTotal: correctAnswers.count)
        }
    }
}
