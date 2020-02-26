//
//  FooterView.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 03/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit

final class FooterView: UIView {
    @IBOutlet private var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var footerBottomConstraint: NSLayoutConstraint!
    
    private var buttonBottomInitialConstraint = CGFloat.init()
    
    override func draw(_ rect: CGRect) {
        //saveButtonBottomConstraintInitialValue()
        //registerKeyboardObservers()
    }
    
    deinit {
        unregisterKeyboardObservers()
    }

    @objc private func keyboardWillChangeFrame(notification:NSNotification) {
        animateFooterForKeyboardNotification(notification)
    }
    
    private func saveButtonBottomConstraintInitialValue() {
        buttonBottomInitialConstraint = buttonBottomConstraint.constant
    }
    
    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillChangeFrame), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillChangeFrame), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func unregisterKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func animateFooterForKeyboardNotification(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        superview?.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0) {
            if notification.name == UIResponder.keyboardWillShowNotification {
                self.buttonBottomConstraint.constant = keyboardFrame.cgRectValue.height + self.buttonBottomInitialConstraint
                self.footerBottomConstraint.constant = keyboardFrame.cgRectValue.height
            } else {
                self.buttonBottomConstraint.constant = self.buttonBottomInitialConstraint
                self.footerBottomConstraint.constant = 0
            }
            self.superview?.layoutIfNeeded()
        }
    }
}
