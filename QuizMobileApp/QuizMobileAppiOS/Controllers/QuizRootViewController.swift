//
//  QuizRootViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

public protocol QuizRootViewControllerDelegate {
    func loadGame()
}

public class QuizRootViewController: UIViewController {
    var delegate: QuizRootViewControllerDelegate?
    var quizHeaderController: QuizHeaderViewController!
    var quizAnswerListController: QuizAnswerListViewController!
    var quizFooterController: QuizFooterViewController!
    
    private var footerContainerBottomConstraintInitialValue = CGFloat.init()
        
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var answerListContainer: UIView!
    @IBOutlet weak var footerContainer: UIView!
    @IBOutlet weak var footerContainerBottomConstraint: NSLayoutConstraint!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addContentForViewController(quizHeaderController, insideContainer: headerContainer)
        addContentForViewController(quizAnswerListController, insideContainer: answerListContainer)
        addContentForViewController(quizFooterController, insideContainer: footerContainer)
        
        registerKeyboardObservers()
        saveFooterContainerBottomConstraintInitialValue()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.loadGame()
    }
    
    deinit {
        unregisterKeyboardObservers()
    }
    
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.endEditing(true)
    }
    
    private func addContentForViewController(_ viewController: UIViewController, insideContainer container: UIView) {
        addChild(viewController)
        viewController.view.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(viewController.view)

        NSLayoutConstraint.activate([
            viewController.view.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            viewController.view.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            viewController.view.topAnchor.constraint(equalTo: container.topAnchor),
            viewController.view.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        viewController.didMove(toParent: self)
    }
    
    private func saveFooterContainerBottomConstraintInitialValue() {
        footerContainerBottomConstraintInitialValue = footerContainerBottomConstraint.constant
    }
    
    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(QuizRootViewController.keyboardWillChangeFrame), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuizRootViewController.keyboardWillChangeFrame), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuizRootViewController.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func unregisterKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    private func animateFooterForKeyboardNotification(_ notification: NSNotification) {
        guard let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        view?.layoutIfNeeded()
        
        UIView.animate(withDuration: 1.0) {
            if notification.name == UIResponder.keyboardWillShowNotification {
                self.footerContainerBottomConstraint.constant = keyboardFrame.cgRectValue.height + self.footerContainerBottomConstraintInitialValue
            } else {
                self.footerContainerBottomConstraint.constant = self.footerContainerBottomConstraintInitialValue
            }
            self.view?.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillChangeFrame(notification:NSNotification) {
        animateFooterForKeyboardNotification(notification)
    }
}
