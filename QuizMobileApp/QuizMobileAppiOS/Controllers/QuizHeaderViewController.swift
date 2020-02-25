//
//  QuizHeaderViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 25/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

protocol QuizHeaderViewControllerDelegate {
    func didTapNewAnswer(_ answer: String)
}

final class QuizHeaderViewController: UIViewController, QuizHeader, UITextFieldDelegate {
    var delegate: QuizHeaderViewControllerDelegate?
    
    @IBOutlet private(set) public var questionLabel: UILabel!
    @IBOutlet private(set) public var answerTextfield: UITextField!
    
    func display(_ presentableModel: QuizHeaderPresentableModel) {
        questionLabel.text = presentableModel.question
        answerTextfield.isUserInteractionEnabled = presentableModel.gameStarted
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        delegate?.didTapNewAnswer(text)
        textField.text = ""
        return true
    }
}
