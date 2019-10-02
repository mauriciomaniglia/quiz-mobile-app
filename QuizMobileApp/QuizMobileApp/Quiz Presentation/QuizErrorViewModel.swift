//
//  QuizErrorViewModel.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public struct QuizErrorViewModel {
    public let message: String?
    
    static var noError: QuizErrorViewModel {
        return QuizErrorViewModel(message: nil)
    }
    
    static func error(message: String) -> QuizErrorViewModel {
        return QuizErrorViewModel(message: message)
    }
}
