//
//  LoadQuestionFromRemoteUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 28/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

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
        
        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0, userInfo: nil)
            store.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        let samples =  [199, 201, 300, 400, 500]
         
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                store.complete(withStatusCode: code, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            store.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let url = URL(fileURLWithPath: "http://a-given-http-url.com")
        let (sut, store) = makeSUT(url: url)
        
        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let emptyData = Data("{}".utf8)
            store.complete(withStatusCode: 200, data: emptyData)
        })
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let url = URL(fileURLWithPath: "http://a-given-http-u rl.com")
        let (sut, store) = makeSUT(url: url)
        let item = makeItem(question: "Question", answer: ["answer1", "answer2"])
        
        expect(sut, toCompleteWith: .success([item.model]), when: {
            let data = try! JSONSerialization.data(withJSONObject: item.json)
            store.complete(withStatusCode: 200, data: data)
        })
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(fileURLWithPath: "http://a-given-http-url.com")) -> (sut: RemoteQuestionLoader, store: HTTPClientSpy) {
        let store = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: url, store: store)
        
        return (sut, store)
    }
    
    private func expect(_ sut: RemoteQuestionLoader, toCompleteWith expectedResult: RemoteQuestionLoader.Result, when action: () -> Void, file: StaticString = #file, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
    }
    
    private func makeItem(question: String, answer: [String]) -> (model: QuestionItem, json: [String: Any]) {
        let questionItem = QuestionItem(question: question, answer: answer)
        let questionJson = makeItemJson(question: question, answer: answer)
        return (questionItem, questionJson)
    }
    
    private func makeItemJson(question: String, answer: [String]) -> [String: Any] {
        return [ "question": question, "answer": answer ] as [String : Any]
    }
    
    private class HTTPClientSpy: HTTPClient {
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

}
