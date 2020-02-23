//
//  RemoteQuestionLoader.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 29/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

public class RemoteQuestionLoader: QuestionLoader {
    private let client: HTTPClient
    private let url: URL
    
    public typealias Result = QuestionLoaderResult
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping (Result) -> Void) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }            
            
            switch result {
            case let .success(data, response):
                completion(RemoteQuestionLoader.map(data, from:response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
    
    private static func map(_ data: Data, from response: HTTPURLResponse) -> Result {
        do {
            let items = try QuestionItemMapper.map(data, from: response)
            return .success(items.toModels())
        } catch {
            return .failure(error)
        }
    }
}

private extension Array where Element == RemoteQuestionItem {
    func toModels() -> [QuestionItem] {
        return map { QuestionItem(question: $0.question, answer: $0.answer) }
    }
}
