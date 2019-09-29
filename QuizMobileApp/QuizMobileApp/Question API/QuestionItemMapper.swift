//
//  QuestionItemMapper.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 29/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

final class QuestionItemMapper {
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) throws -> [QuestionItem] {
        guard response.statusCode == OK_200,
            let item = try? JSONDecoder().decode(QuestionItem.self, from: data) else {
            throw RemoteQuestionLoader.Error.invalidData
        }

        return [item]
    }
}
