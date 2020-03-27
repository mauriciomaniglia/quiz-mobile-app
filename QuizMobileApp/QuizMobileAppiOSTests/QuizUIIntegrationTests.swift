//
//  QuizUIIntegrationTests.swift
//  QuizMobileAppiOSTests
//
//  Created by Mauricio Cesar Maniglia Junior on 27/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp
import QuizMobileAppiOS

class QuizUIIntegrationTests: XCTestCase {
    
    func test_loadActions_requestQuizFromLoader() {
        let loader = LoaderSpy()
        let sut = QuizUIComposer.quizComposedWith(questionLoader: loader)
        
        XCTAssertEqual(loader.loadCallCount, 0, "Expected no loading requests before view is loaded")
        
        sut.viewDidAppear(false)
        
        XCTAssertEqual(loader.loadCallCount, 1, "Expected a loading request once view is loaded")
        
        sut.viewDidAppear(false)
        
        XCTAssertEqual(loader.loadCallCount, 2, "Expected another loading request once view is loaded again")
    }
    
    private class LoaderSpy: QuestionLoader {
        var loadCallCount = 0
        
        func load(completion: @escaping (QuestionLoaderResult) -> Void) {
            loadCallCount += 1
        }
    }
}
