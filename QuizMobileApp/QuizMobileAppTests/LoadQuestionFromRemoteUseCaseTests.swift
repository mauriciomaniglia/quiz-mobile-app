//
//  LoadQuestionFromRemoteUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 28/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class RemoteQuestionLoader {
    private let store: HTTPClientSpy
    private let url: URL
    
    enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    enum Result: Equatable {
        case success([QuestionItem])
        case failure(Error)
    }
    
    init(url: URL, store: HTTPClientSpy) {
        self.url = url
        self.store = store
    }
    
    func load(completion: @escaping (Result) -> Void) {
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

enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

class HTTPClientSpy {
    var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
    
    var requestedURLs: [URL] {
        return messages.map { $0.url }
    }
    
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
        messages.append((url, completion))
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index].completion(.failure(error))
    }
    
    func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
            )!
        messages[index].completion(.success(data, response))
    }
}

class LoadQuestionFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(store.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(store.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        let clientError = NSError(domain: "Test", code: 0, userInfo: nil)
            
        var captureError = [RemoteQuestionLoader.Result]()
        sut.load { error in
            captureError.append(error)
        }
        store.complete(with: clientError)
        
        XCTAssertEqual(captureError, [.failure(.connectivity)])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        let samples =  [199, 201, 300, 400, 500]
         
        samples.enumerated().forEach { index, code in
            var captureError = [RemoteQuestionLoader.Result]()
            sut.load { error in
                captureError.append(.failure(.invalidData))
            }
            store.complete(withStatusCode: code, at: index)
            
            XCTAssertEqual(captureError, [.failure(.invalidData)])
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        let invalidJSON = Data("invalid json".utf8)

        var captureError = [RemoteQuestionLoader.Result]()
        sut.load { error in
            captureError.append(error)
        }
        store.complete(withStatusCode: 200, data: invalidJSON)

        XCTAssertEqual(captureError, [.failure(.invalidData)])
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        let emptyData = Data("{}".utf8)

        var captureError = [RemoteQuestionLoader.Result]()
        sut.load { error in
            captureError.append(error)
        }
        store.complete(withStatusCode: 200, data: emptyData)

        XCTAssertEqual(captureError, [.failure(.invalidData)])
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let url = URL(fileURLWithPath: "http://a-given-http-u rl.com")
        let (sut, store) = makeSUT(url: url)
        let answer = ["abstract", "assert", "boolean"]
        let json = [ "question": "What are all the java keywords?",
                    "answer": answer ] as [String : Any]
        let data = try! JSONSerialization.data(withJSONObject: json)
        let questionItem = QuestionItem(question: "What are all the java keywords?", answer: answer)

        var captureError = [RemoteQuestionLoader.Result]()
        sut.load { error in
            captureError.append(error)
        }
        store.complete(withStatusCode: 200, data: data)

        XCTAssertEqual(captureError, [.success([questionItem])])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(fileURLWithPath: "http://a-given-http-url.com")) -> (sut: RemoteQuestionLoader, store: HTTPClientSpy) {
        let store = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: url, store: store)
        
        return (sut, store)
    }

}
