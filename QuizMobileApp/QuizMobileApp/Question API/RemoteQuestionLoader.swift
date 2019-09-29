//
//  RemoteQuestionLoader.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 29/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public class RemoteQuestionLoader {
    private let store: HTTPClient
    private let url: URL
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public enum Result: Equatable {
        case success([QuestionItem])
        case failure(Error)
    }
    
    public init(url: URL, store: HTTPClient) {
        self.url = url
        self.store = store
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        store.get(from: url) { result in
            switch result {
            case let .success(data, _):
                if let question = try? JSONDecoder().decode(QuestionItem.self, from: data) {
                    completion(.success([question]))
                } else {
                    completion(.failure(Error.invalidData))
                }
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
