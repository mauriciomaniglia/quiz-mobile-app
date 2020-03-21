//
//  GameDelegateSpy.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 20/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import QuizMobileApp

class GameDelegateSpy: QuizGameDelegate, QuizCounterDelegate {
    var gameStatus: GameStatus?
    var counterSecondsCalls = 0
    var counterResetedCalls = 0
    var counterStoppedCalls = 0
    
    func gameStatus(_ gameStatus: GameStatus) {
        self.gameStatus = gameStatus
    }
    
    func counterSeconds(_ seconds: Int) {
        counterSecondsCalls += 1
    }
    
    func counterReseted(_ seconds: Int) {
        counterResetedCalls += 1
    }
    
    func counterStopped(_ seconds: Int) {
        counterStoppedCalls += 1
    }
}
