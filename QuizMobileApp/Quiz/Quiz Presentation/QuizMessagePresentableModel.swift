//
//  QuizMessagePresentableModel.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 28/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public struct QuizMessagePresentableModel {
    public let title: String?
    public let message: String
    public let retry: String
        
    static func error(message: String, retry: String) -> QuizMessagePresentableModel {
        return QuizMessagePresentableModel(title: nil, message: message, retry: retry)
    }
}
