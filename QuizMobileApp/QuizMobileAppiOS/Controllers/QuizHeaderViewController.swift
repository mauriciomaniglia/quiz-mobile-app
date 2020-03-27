//
//  QuizHeaderViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 25/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

public protocol QuizHeaderViewControllerDelegate {
    func didTapNewAnswer(_ answer: String)
}

public final class QuizHeaderViewController: UIViewController, QuizHeader, UITextFieldDelegate {
    var delegate: QuizHeaderViewControllerDelegate?
    
    @IBOutlet private(set) public var questionLabel: UILabel!
    @IBOutlet private(set) public var answerTextfield: UITextField!    
    
    public func display(_ presentableModel: QuizHeaderPresentableModel) {
        if let question = presentableModel.question {
            questionLabel.text = question
        }
        answerTextfield.isUserInteractionEnabled = presentableModel.gameStarted
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        delegate?.didTapNewAnswer(text)
        textField.text = ""
        return true
    }
}
