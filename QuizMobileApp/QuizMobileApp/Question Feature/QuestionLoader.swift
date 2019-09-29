//
//  QuestionLoader.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 28/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public enum QuestionLoaderResult {
    case success([QuestionItem])
    case failure(Error)
}

public protocol QuestionLoader {
    func load(completion: @escaping (QuestionLoaderResult) -> Void)
}
