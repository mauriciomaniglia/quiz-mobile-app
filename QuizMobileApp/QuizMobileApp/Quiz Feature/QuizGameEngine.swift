//
//  QuizGameEngine.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 30/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public final class QuizGameEngine: QuizGame, QuizCounterDelegate {
    public var delegate: QuizGameDelegate?
    
    private let counter: QuizCounter
    private let correctAnswers: [String]
    private var savedAnswers = [String]()
    
    public init(counter: QuizCounter, correctAnswers: [String]) {
        self.counter = counter        
        self.correctAnswers = correctAnswers
    }
    
    public func start() {
        counter.start()
    }
    
    public func reset() {
        savedAnswers = []
        counter.reset()
    }
    
    public func addAnswer(_ answer: String) {
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAnswer.isEmpty else { return }
        guard !savedAnswers.contains(trimmedAnswer) else { return }
        guard savedAnswers.count < correctAnswers.count else { return }
        
        savedAnswers.append(trimmedAnswer)
        validateAnswers()
    }
    
    // MARK: Counter delegate
    
    public func counterSeconds(_ seconds: Int) {
        updateGameStatus(isGameStarted: true, isGameFinished: false, seconds: seconds)
    }
    
    public func counterReseted(_ seconds: Int) {
        updateGameStatus(isGameStarted: false, isGameFinished: false, seconds: seconds)
    }
    
    public func counterStopped(_ seconds: Int) {
        updateGameStatus(isGameStarted: true, isGameFinished: true, seconds: seconds)
    }
    
    // MARK: Helpers
    
    private func updateGameStatus(isGameStarted: Bool, isGameFinished: Bool, seconds: Int) {
        let gameStatus = GameStatus(isGameStarted: isGameStarted,
                                    isGameFinished: isGameFinished,
                                    currentSeconds: seconds,
                                    correctAnswers: correctAnswers,
                                    userAnswers: savedAnswers)
        
        delegate?.gameStatus(gameStatus)
    }
    
    private func validateAnswers() {
        if savedAnswers.count == correctAnswers.count {
            counter.stop()
        }
    }
}
