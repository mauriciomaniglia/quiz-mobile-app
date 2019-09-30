//
//  QuestionItem.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 28/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public struct QuestionItem: Equatable {    
    let question: String
    let answer: [String]
    
    public init(question: String, answer: [String]) {
        self.question = question
        self.answer = answer
    }
}