//
//  QuizRootViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import Quiz

public protocol QuizRootViewControllerDelegate {
    func loadGame()
}

public class QuizRootViewController: UIViewController {
    public var delegate: QuizRootViewControllerDelegate?
    public var quizHeaderController: QuizHeaderViewController!
    public var quizAnswerListController: QuizAnswerListViewController!
    public var quizFooterController: QuizFooterViewController!
        
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var answerListContainer: UIView!
    @IBOutlet weak var footerContainer: UIView!
    @IBOutlet weak var footerContainerBottomConstraint: NSLayoutConstraint!
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addContentForViewController(quizHeaderController, insideContainer: headerContainer)
        addContentForViewController(quizAnswerListController, insideContainer: answerListContainer)
        addContentForViewController(quizFooterController, insideContainer: footerContainer)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        delegate?.loadGame()
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
}
