//
//  QuizGameEngine.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public final class QuizGameEngine {
    private let counter: Counter
    private let correctAnswers: [String]
    private var savedAnswers = [String]()
    
    public typealias AddAnswerResult = (savedAnswers: [String], correctAnswersTotal: Int)
    
    public enum QuizGameEngineResult: Equatable {
        case gameStarted
        case updateSecond(Int)
    }
    
    public init(counter: Counter, correctAnswers: [String]) {
        self.counter = counter
        self.correctAnswers = correctAnswers
    }
    
    public func startGame(completion: @escaping (QuizGameEngineResult) -> Void) {
        self.counter.start { [weak self] counterResult in
            guard self != nil else { return }
            
            switch counterResult {
            case .start:
                completion(.gameStarted)
            case let .currentSecond(second):
                completion(.updateSecond(second))
            case .reset: break                
            }
        }
    }
    
    public func addAnswer(_ answer: String, completion: @escaping (AddAnswerResult) -> Void) {
        
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedAnswer.isEmpty else { return }
        guard savedAnswers.count < correctAnswers.count else { return }
        
        savedAnswers.append(trimmedAnswer)
        
        completion((savedAnswers, correctAnswers.count))
    }
    
    public func restartGame(completion: @escaping () -> Void) {
        counter.reset()
        savedAnswers = []
    }
}
