//
//  LoadQuestionFromRemoteUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 28/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest

class RemoteQuestionLoader {
    private let store: HTTPClientSpy
    private let url: URL
    
    init(url: URL, store: HTTPClientSpy) {
        self.url = url
        self.store = store
    }
    
    func load(completion: @escaping (Error) -> Void) {
        store.get(from: url) { error in
            completion(error)
        }
    }
}

class HTTPClientSpy {
    var requestedURLs = [URL]()
    var messages = [(Error) -> Void]()
    
    func get(from url: URL, completion: @escaping (Error) -> Void) {
        messages.append(completion)
        requestedURLs.append(url)
    }
    
    func complete(with error: Error, at index: Int = 0) {
        messages[index](error)
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
        
        var receivedError: Error?
        sut.load { error in
            receivedError = error
        }
        store.complete(with: clientError)
        
        XCTAssertEqual(receivedError as NSError?, clientError)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(fileURLWithPath: "http://a-given-http-url.com")) -> (sut: RemoteQuestionLoader, store: HTTPClientSpy) {
        let store = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: url, store: store)
        
        return (sut, store)
    }

}
