//
//  CounterSpy.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 01/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation
import QuizMobileApp

public class CounterSpy: Counter {
    var messages = [CounterResult]()
    var seconds = 0
    var startCompletions = [(CounterResult) -> Void]()
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    public func start(completion: @escaping (CounterResult) -> Void) {
        guard seconds > 0 else { return }
        messages.append(.start)
        
        while seconds > 0 {
            messages.append(.currentSecond(seconds))
            startCompletions.append(completion)
            
            seconds -= 1
        }
    }
    
    func startGameMessage(at index: Int = 0) {
        guard startCompletions.count > 0 else { return }
        
        startCompletions[index](.start)
    }
    
    func sendCurrentSecond(at index: Int = 0) {
        guard startCompletions.count > 0 else { return }
        
        startCompletions[index](.currentSecond(seconds))
    }
    
    public func reset() {
        messages.append(.reset)
    }
}
