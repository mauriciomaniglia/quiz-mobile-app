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
    
    func load() {
        store.get(from: url)
    }
}

class HTTPClientSpy {
    var requestedURLs = [URL]()
    
    func get(from url: URL) {
        requestedURLs.append(url)
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
        
        sut.load()
        
        XCTAssertEqual(store.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(store.requestedURLs, [url, url])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(fileURLWithPath: "http://a-given-http-url.com")) -> (sut: RemoteQuestionLoader, store: HTTPClientSpy) {
        let store = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: url, store: store)
        
        return (sut, store)
    }

}
