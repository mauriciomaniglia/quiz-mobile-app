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
    private var savedAnswers = [String]()
    
    public enum QuizGameEngineResult: Equatable {
        case gameStarted
        case updateSecond(Int)
    }
    
    public init(counter: Counter) {
        self.counter = counter
    }
    
    public func startGame(completion: @escaping (QuizGameEngineResult) -> Void) {
        self.counter.start { [weak self] counterResult in
            guard self != nil else { return }
            
            switch counterResult {
            case .start:
                completion(.gameStarted)
            case let .currentSecond(second):
                completion(.updateSecond(second))
            }
        }
    }
    
    public func addAnswer(_ answer: String, completion: @escaping ([String]) -> Void) {
        
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !trimmedAnswer.isEmpty else { return }
        
        savedAnswers.append(trimmedAnswer)
        
        completion(savedAnswers)
    }
}
