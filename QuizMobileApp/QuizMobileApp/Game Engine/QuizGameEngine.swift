//
//  QuizGameEngine.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public final class QuizGameEngine: QuizGame {
    private let counter: Counter
    private let correctAnswers: [String]
    private var savedAnswers = [String]()
    private var savedAnswersCorrect = 0
    
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
    
    public func restartGame(completion: @escaping (FinalResult) -> Void) {
        counter.reset()
        savedAnswers = []
        savedAnswersCorrect = 0
        completion(FinalResult(scoreAll: false, savedAnswersCorrect: 0, correctAnswersTotal: correctAnswers.count))
    }
    
    private func validateAnswers() {
        if savedAnswers.count == correctAnswers.count {
            counter.stop()
        }
    }
    
    private func gameResult() -> FinalResult {
        if savedAnswersCorrect == correctAnswers.count {
            return FinalResult(scoreAll: true, savedAnswersCorrect: savedAnswersCorrect, correctAnswersTotal: correctAnswers.count)
        } else {
            return FinalResult(scoreAll: false, savedAnswersCorrect: savedAnswersCorrect, correctAnswersTotal: correctAnswers.count)
        }
    }
}
