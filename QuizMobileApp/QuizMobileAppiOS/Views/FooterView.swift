//
//  FooterView.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 03/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit

final class FooterView: UIView {
    override func updateConstraints() {
        super.updateConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillChangeFrame), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillChangeFrame), name: UIResponder.keyboardWillHideNotification, object: nil)
         NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc private func keyboardWillChangeFrame(notification:NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
                
        if notification.name == UIResponder.keyboardWillShowNotification {
            superview?.frame.origin.y = -keyboardFrame.cgRectValue.height
        } else {
            superview?.frame.origin.y = 0
        }
    }
}
