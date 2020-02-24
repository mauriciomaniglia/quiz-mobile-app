//
//  QuizErrorPresentableModel.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public struct QuizErrorPresentableModel {
    public let message: String
    public let retry: String
        
    static func error(message: String, retry: String) -> QuizErrorPresentableModel {
        return QuizErrorPresentableModel(message: message, retry: retry)
    }
}
