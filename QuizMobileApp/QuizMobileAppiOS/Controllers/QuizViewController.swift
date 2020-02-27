//
//  QuizViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

protocol QuizViewControllerDelegate {
    func didRequestLoading()
}

class QuizViewController: UIViewController, QuizErrorView, QuizResultView {
    var delegate: QuizViewControllerDelegate?
    var quizHeaderController: QuizHeaderViewController!
    var quizAnswerListController: QuizAnswerListViewController!
    var quizFooterController: QuizFooterViewController!
    
    private var footerContainerBottomConstraintInitialValue = CGFloat.init()
        
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var answerListContainer: UIView!
    @IBOutlet weak var footerContainer: UIView!
    @IBOutlet weak var footerContainerBottomConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addHeaderContent()
        addAnswerListContent()
        addFooterContent()
        
        registerKeyboardObservers()
        saveFooterContainerBottomConstraintInitialValue()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.didRequestLoading()
    }
    
    deinit {
        unregisterKeyboardObservers()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.endEditing(true)
    }
    
    func display(_ viewModel: QuizErrorPresentableModel) {
        let retryButton = UIAlertAction(title: viewModel.retry, style: .default, handler: { _ in self.delegate?.didRequestLoading() })
        alertWithTitle(viewModel.message, message: nil, action: retryButton)
    }
    
    func display(_ viewModel: QuizResultPresentableModel) {                
        let retryButton = UIAlertAction(title: viewModel.retry, style: .default, handler: { _ in /*self.delegate?.didClickStatusButton()*/ })
        alertWithTitle(viewModel.title, message: viewModel.message, action: retryButton)
    }
    
    private func alertWithTitle(_ title: String, message: String?, action: UIAlertAction) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(action)
        present(alert, animated: false)
    }
    
    private func addHeaderContent() {
        addChild(quizHeaderController)
        quizHeaderController.view.translatesAutoresizingMaskIntoConstraints = false
        headerContainer.addSubview(quizHeaderController.view)

        NSLayoutConstraint.activate([
            quizHeaderController.view.leadingAnchor.constraint(equalTo: headerContainer.leadingAnchor),
            quizHeaderController.view.trailingAnchor.constraint(equalTo: headerContainer.trailingAnchor),
            quizHeaderController.view.topAnchor.constraint(equalTo: headerContainer.topAnchor),
            quizHeaderController.view.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor)
        ])

        quizHeaderController.didMove(toParent: self)
    }
    
    private func addAnswerListContent() {
        addChild(quizAnswerListController)
        quizAnswerListController.view.translatesAutoresizingMaskIntoConstraints = false
        answerListContainer.addSubview(quizAnswerListController.view)

        NSLayoutConstraint.activate([
            quizAnswerListController.view.leadingAnchor.constraint(equalTo: answerListContainer.leadingAnchor),
            quizAnswerListController.view.trailingAnchor.constraint(equalTo: answerListContainer.trailingAnchor),
            quizAnswerListController.view.topAnchor.constraint(equalTo: answerListContainer.topAnchor),
            quizAnswerListController.view.bottomAnchor.constraint(equalTo: answerListContainer.bottomAnchor)
        ])

        quizAnswerListController.didMove(toParent: self)
    }
    
    private func addFooterContent() {
        addChild(quizFooterController)
        quizFooterController.view.translatesAutoresizingMaskIntoConstraints = false
        footerContainer.addSubview(quizFooterController.view)

        NSLayoutConstraint.activate([
            quizFooterController.view.leadingAnchor.constraint(equalTo: footerContainer.leadingAnchor),
            quizFooterController.view.trailingAnchor.constraint(equalTo: footerContainer.trailingAnchor),
            quizFooterController.view.topAnchor.constraint(equalTo: footerContainer.topAnchor),
            quizFooterController.view.bottomAnchor.constraint(equalTo: footerContainer.bottomAnchor)
        ])

        quizFooterController.didMove(toParent: self)
    }
    
    private func saveFooterContainerBottomConstraintInitialValue() {
        footerContainerBottomConstraintInitialValue = footerContainerBottomConstraint.constant
    }
    
    private func registerKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(QuizViewController.keyboardWillChangeFrame), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuizViewController.keyboardWillChangeFrame), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(QuizViewController.keyboardWillChangeFrame), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
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
