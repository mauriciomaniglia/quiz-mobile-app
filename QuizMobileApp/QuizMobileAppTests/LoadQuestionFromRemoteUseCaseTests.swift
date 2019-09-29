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
    
    init(url: URL, store: HTTPClientSpy) {
        self.url = url
        self.store = store
    }
    
    func load(completion: @escaping (Error) -> Void) {
        store.get(from: url) { error, response in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivity)
            }
        }
    }
}

class HTTPClientSpy {
    var requestedURLs = [URL]()
    var messages = [(Error?, HTTPURLResponse?) -> Void]()
    
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
        messages.append(completion)
        requestedURLs.append(url)
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index](error, nil)
    }
    
    func complete(withStatusCode code: Int, at index: Int = 0) {
        let response = HTTPURLResponse(
            url: requestedURLs[index],
            statusCode: code,
            httpVersion: nil,
            headerFields: nil
            )!
        messages[index](nil, response)
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
            
        var captureError = [RemoteQuestionLoader.Error]()
        sut.load { error in
            captureError.append(error)
        }
        store.complete(with: clientError)
        
        XCTAssertEqual(captureError, [.connectivity])
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        let samples =  [199, 201, 300, 400, 500]
         
        samples.enumerated().forEach { index, code in
            var captureError = [RemoteQuestionLoader.Error]()
            sut.load { error in
                captureError.append(error)
            }
            store.complete(withStatusCode: code, at: index)
            
            XCTAssertEqual(captureError, [.invalidData])
        }
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(fileURLWithPath: "http://a-given-http-url.com")) -> (sut: RemoteQuestionLoader, store: HTTPClientSpy) {
        let store = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: url, store: store)
        
        return (sut, store)
    }

}
