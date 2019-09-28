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
    
    init(store: HTTPClientSpy) {
        self.store = store
    }
    
    func load() {}
}

class HTTPClientSpy {
    var requestedURLsCallCount = 0
}

class LoadQuestionFromRemoteUseCaseTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let store = HTTPClientSpy()
        _ = RemoteQuestionLoader(store: store)                
        
        XCTAssertEqual(store.requestedURLsCallCount, 0)
    }

}
