//
//  FooterView.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 03/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit

final class FooterView: UIView {
    @IBOutlet private var footerContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet private var buttonBottomConstraint: NSLayoutConstraint!
    private var isKeyboardOpen = false
    
    override func updateConstraints() {
        super.updateConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(FooterView.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard isKeyboardOpen == false else { return }
        isKeyboardOpen = true
        
        UIView.animate(withDuration: 2.0, animations: {
            self.footerContainerBottomConstraint.constant += self.keyboardHeight(notification) ?? 0
            print("will show \(self.footerContainerBottomConstraint.constant)")
            self.buttonBottomConstraint.constant += self.keyboardHeight(notification) ?? 0
        })
    }
     
    @objc func keyboardWillHide(notification:NSNotification) {
        guard isKeyboardOpen == true else { return }
        isKeyboardOpen = false
        
        UIView.animate(withDuration: 2.0, animations: {
            self.footerContainerBottomConstraint.constant -= self.keyboardHeight(notification) ?? 0
            print("will hide \(self.footerContainerBottomConstraint.constant)")
            self.buttonBottomConstraint.constant -= self.keyboardHeight(notification) ?? 0
        })
    }
    
    func keyboardHeight(_ notification: NSNotification) -> CGFloat? {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            return keyboardRectangle.height
        }
        return nil
    }

}
