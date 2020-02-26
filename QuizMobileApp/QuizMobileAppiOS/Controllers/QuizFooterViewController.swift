//
//  QuizFooterViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 26/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

public protocol QuizFooterViewControllerDelegate {
    func didClickStatusButton()
}

final class QuizFooterViewController: UIViewController, QuizFooter {
    var delegate: QuizFooterViewControllerDelegate?
    
    @IBOutlet private(set) public var statusButton: UIButton!
    @IBOutlet private(set) public var counterLabel: UILabel!
    @IBOutlet private(set) public var answerCountLabel: UILabel!
    
    @IBAction func didTapStatusButton() {
        delegate?.didClickStatusButton()
    }
    
    func display(_ presentableModel: QuizFooterPresentableModel) {
        if let buttonTitle = presentableModel.status {
            statusButton.setTitle(buttonTitle, for: .normal)
        }
        
        if let counterText = presentableModel.seconds {
            counterLabel.text = counterText
        }
        
        if let answerCountText = presentableModel.answerCount {
            answerCountLabel.text = answerCountText
        }
    }
}
