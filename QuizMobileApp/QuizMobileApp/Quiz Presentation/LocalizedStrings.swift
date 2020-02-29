//
//  LocalizedStrings.swift
//  QuizMobileApp
//
//  Created by Mauricio Cesar Maniglia Junior on 29/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import Foundation

class LocalizedStrings {
    static var startGameText: String {
        return localizedString("QUIZ_START_STATUS", comment: "Title for the start game status")
    }
    
    static var resetGameText: String {
        return localizedString("QUIZ_RESET_STATUS", comment: "Title for the reset game status")
    }
    
    static var congratulationsTitleText: String {
        return localizedString("QUIZ_CONGRATULATIONS_TITLE", comment: "Congratulations title for the game final result")
    }
    
    static var congratulationsMessageText: String {
        return localizedString("QUIZ_CONGRATULATIONS_MESSAGE", comment: "Congratulations message for the game final result")
    }
    
    static var playAgainTitleText: String {
        return localizedString("QUIZ_PLAY_AGAIN_TITLE", comment: "Title for play again message on game final result")
    }
    
    static var timeFinishedTitleText: String {
        return localizedString("QUIZ_TIME_FINISHED_TITLE", comment: "Time finished title for the game final result")
    }
    
    static var timeFinishedMessageText: String {
        return localizedString("QUIZ_TIME_FINISHED_MESSAGE", comment: "Time finished message for the game final result")
    }
    
    static var tryAgainTitleText: String {
        return localizedString("QUIZ_TRY_AGAIN_TITLE", comment: "Title for try again message on game final result")
    }
    
    static var errorMessageText: String {
        return localizedString("QUIZ_ERROR_MESSAGE", comment: "Message for connection error")
    }
    
    private static func localizedString(_ key: String, comment: String, placeholders: String...) -> String {
        return NSLocalizedString(key,
                                 tableName: "Quiz",
                                 bundle: Bundle(for: LocalizedStrings.self),
                                 comment: comment)
    }
}
