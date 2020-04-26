//
//  CustomTextField.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 03/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    override func awakeFromNib() {
        addPaddingLeft()
        layer.cornerRadius = 5
    }
    
    private func addPaddingLeft() {
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 43))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
}
