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
    var requestedURLsCallCount = 0
    
    func get(from url: URL) {
        requestedURLsCallCount += 1
    }
}

class LoadQuestionFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let store = HTTPClientSpy()
        _ = RemoteQuestionLoader(url: URL(fileURLWithPath: "http://a-given-http-url.com"), store: store)
        
        XCTAssertEqual(store.requestedURLsCallCount, 0)
    }
    
    func test_load_requestsDataFromURL() {
        let store = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: URL(fileURLWithPath: "http://a-given-http-url.com"), store: store)
        
        sut.load()
        
        XCTAssertEqual(store.requestedURLsCallCount, 1)
    }

}
