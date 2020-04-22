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
    private var currentSeconds = 0
    private var isGameStarted = false
    
    public init(counter: QuizCounter, correctAnswers: [String]) {
        self.counter = counter        
        self.correctAnswers = correctAnswers
    }
    
    public func start() {
        isGameStarted = true
        counter.start()
    }
    
    public func reset() {
        savedAnswers = []
        counter.reset()
        isGameStarted = false
    }
    
    public func addAnswer(_ answer: String) {
        guard isGameStarted else { return }
        
        let answer = removeEmptySpaces(string: answer)
        
        if isValidAnswer(answer) {
            savedAnswers.append(answer)
        }
                                        
        checkIfGameFinished()
        updateGameStatus(isGameStarted: isGameStarted, isGameFinished: false, seconds: counter.currentSeconds())
    }
    
    // MARK: Counter delegate
    
    public func counterSeconds(_ seconds: Int) {
        updateGameStatus(isGameStarted: isGameStarted, isGameFinished: false, seconds: seconds)
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
    
    private func removeEmptySpaces(string: String) -> String {
        return string.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    private func isValidAnswer(_ answer: String) -> Bool {
        if answer.isEmpty || savedAnswers.contains(answer) || !correctAnswers.contains(answer) {
            return false
        }
        
        return true
    }
    
    private func checkIfGameFinished() {
        if savedAnswers.count == correctAnswers.count {
            counter.stop()
        }
    }
}
