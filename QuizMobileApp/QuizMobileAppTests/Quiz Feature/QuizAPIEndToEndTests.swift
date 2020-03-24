//
//  QuizAPIEndToEndTests.swift
//  QuizMobileAppTests
//
//  Created by Mauricio Cesar Maniglia Junior on 24/03/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import XCTest
import QuizMobileApp

class QuizAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETQuizResult_matchesFixedTestAccountData() {
        switch getQuizResult() {
        case let .success(quizResult)?:
            XCTAssertEqual(quizResult.count, 1, "Expected 1 quiz question")
            XCTAssertEqual(quizResult.first?.question, "What are all the java keywords?")
            XCTAssertEqual(quizResult.first?.answer[0], answers(at: 0))
            XCTAssertEqual(quizResult.first?.answer[1], answers(at: 1))
            XCTAssertEqual(quizResult.first?.answer[2], answers(at: 2))
            XCTAssertEqual(quizResult.first?.answer[3], answers(at: 3))
            XCTAssertEqual(quizResult.first?.answer[4], answers(at: 4))
            XCTAssertEqual(quizResult.first?.answer[5], answers(at: 5))
            XCTAssertEqual(quizResult.first?.answer[6], answers(at: 6))
            XCTAssertEqual(quizResult.first?.answer[7], answers(at: 7))
            XCTAssertEqual(quizResult.first?.answer[8], answers(at: 8))
            XCTAssertEqual(quizResult.first?.answer[9], answers(at: 9))
            XCTAssertEqual(quizResult.first?.answer[10], answers(at: 10))
            XCTAssertEqual(quizResult.first?.answer[11], answers(at: 11))
            XCTAssertEqual(quizResult.first?.answer[12], answers(at: 12))
            XCTAssertEqual(quizResult.first?.answer[13], answers(at: 13))
            XCTAssertEqual(quizResult.first?.answer[14], answers(at: 14))
            XCTAssertEqual(quizResult.first?.answer[15], answers(at: 15))
            XCTAssertEqual(quizResult.first?.answer[16], answers(at: 16))
            XCTAssertEqual(quizResult.first?.answer[17], answers(at: 17))
            XCTAssertEqual(quizResult.first?.answer[18], answers(at: 18))
            XCTAssertEqual(quizResult.first?.answer[19], answers(at: 19))
            XCTAssertEqual(quizResult.first?.answer[20], answers(at: 20))
            XCTAssertEqual(quizResult.first?.answer[21], answers(at: 21))
            XCTAssertEqual(quizResult.first?.answer[22], answers(at: 22))
            XCTAssertEqual(quizResult.first?.answer[23], answers(at: 23))
            XCTAssertEqual(quizResult.first?.answer[24], answers(at: 24))
            XCTAssertEqual(quizResult.first?.answer[25], answers(at: 25))
            XCTAssertEqual(quizResult.first?.answer[26], answers(at: 26))
            XCTAssertEqual(quizResult.first?.answer[27], answers(at: 27))
            XCTAssertEqual(quizResult.first?.answer[28], answers(at: 28))
            XCTAssertEqual(quizResult.first?.answer[29], answers(at: 29))
            XCTAssertEqual(quizResult.first?.answer[30], answers(at: 30))
            XCTAssertEqual(quizResult.first?.answer[31], answers(at: 31))
            XCTAssertEqual(quizResult.first?.answer[32], answers(at: 32))
            XCTAssertEqual(quizResult.first?.answer[33], answers(at: 33))
            XCTAssertEqual(quizResult.first?.answer[34], answers(at: 34))
            XCTAssertEqual(quizResult.first?.answer[35], answers(at: 35))
            XCTAssertEqual(quizResult.first?.answer[36], answers(at: 36))
            XCTAssertEqual(quizResult.first?.answer[37], answers(at: 37))
            XCTAssertEqual(quizResult.first?.answer[38], answers(at: 38))
            XCTAssertEqual(quizResult.first?.answer[39], answers(at: 39))
            XCTAssertEqual(quizResult.first?.answer[40], answers(at: 40))
            XCTAssertEqual(quizResult.first?.answer[41], answers(at: 41))
            XCTAssertEqual(quizResult.first?.answer[42], answers(at: 42))
            XCTAssertEqual(quizResult.first?.answer[43], answers(at: 43))
            XCTAssertEqual(quizResult.first?.answer[44], answers(at: 44))
            XCTAssertEqual(quizResult.first?.answer[45], answers(at: 45))
            XCTAssertEqual(quizResult.first?.answer[46], answers(at: 46))
            XCTAssertEqual(quizResult.first?.answer[47], answers(at: 47))
            XCTAssertEqual(quizResult.first?.answer[48], answers(at: 48))
            XCTAssertEqual(quizResult.first?.answer[49], answers(at: 49))
        case let .failure(error)?:
            XCTFail("Expected successful quiz result, got \(error) instead")
        default:
            XCTFail("Expected successful quiz result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getQuizResult(file: StaticString = #file, line: UInt = #line) -> QuestionLoaderResult? {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteQuestionLoader(url: quizTestServerURL, client: client)
        
        trackForMemoryLeak(client, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: QuestionLoaderResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        
        return receivedResult
    }
    
    private var quizTestServerURL: URL {
        return URL(string: "https://raw.githubusercontent.com/mauriciomaniglia/quiz-mobile-app/master/quiz.api")!
    }
    
    private func answers(at index: Int) -> String? {
        return [
            "abstract",
            "assert",
            "boolean",
            "break",
            "byte",
            "case",
            "catch",
            "char",
            "class",
            "const",
            "continue",
            "default",
            "do",
            "double",
            "else",
            "enum",
            "extends",
            "final",
            "finally",
            "float",
            "for",
            "goto",
            "if",
            "implements",
            "import",
            "instanceof",
            "int",
            "interface",
            "long",
            "native",
            "new",
            "package",
            "private",
            "protected",
            "public",
            "return",
            "short",
            "static",
            "strictfp",
            "super",
            "switch",
            "synchronized",
            "this",
            "throw",
            "throws",
            "transient",
            "try",
            "void",
            "volatile",
            "while"
            ][index]
    }
}
