//
//  QuizMessageComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 14/04/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

final class QuizMessageComposer {
    var loadGame: (() -> Void)?
    var restartGame: (() -> Void)?
    
    private var messagePresenter: QuizMessagePresenter?
    private lazy var rootViewController: UIViewController? = {
        return UIApplication.shared.keyWindow!.rootViewController
    }()
            
    private func alertWithTitle(_ title: String?, message: String?, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        rootViewController?.present(alert, animated: true)
    }
    
    func showLoadingError(_ error: Error) {
        if messagePresenter == nil {
            messagePresenter = QuizMessagePresenter(messageView: self)
        }
        
        messagePresenter?.didFinishLoadGame(with: error)
    }
    
    func showFinishedGame(_ gameStatus: GameStatus) {
       if messagePresenter == nil {
            messagePresenter = QuizMessagePresenter(messageView: self)
        }
        
        messagePresenter?.didFinishGame(gameStatus)
    }
}

extension QuizMessageComposer: QuizMessage {
    func displayErrorMessage(_ presentableModel: QuizMessagePresentableModel) {
        let retryButton = UIAlertAction(title: presentableModel.retry, style: .default, handler: { _ in
            self.rootViewController?.dismiss(animated: false, completion: nil)
            QuizLoadingComposer.hideLoading()
            self.loadGame?()
        })
        alertWithTitle(presentableModel.message, message: nil, action: retryButton)
    }
    
    func displayMessage(_ presentableModel: QuizMessagePresentableModel) {
        let retryButton = UIAlertAction(title: presentableModel.retry, style: .default, handler: { _ in self.restartGame?() })
        alertWithTitle(presentableModel.title, message: presentableModel.message, action: retryButton)
    }
}
