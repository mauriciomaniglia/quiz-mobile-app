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

class QuizViewController: UIViewController, QuizAnswerView, QuizLoadingView, QuizErrorView, QuizResultView, UITableViewDataSource {
    var delegate: QuizViewControllerDelegate?
    
    @IBOutlet private(set) public var tableView: UITableView!
    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet weak var footerContainer: UIView!
    
    var quizHeaderController: QuizHeaderViewController!
    var quizFooterController: QuizFooterViewController!
    
    var tableModel = [String]() {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didRequestLoading()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.keyboardDismissMode = .onDrag
        
        addHeaderContent()
        addFooterContent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.endEditing(true)
    }
    
    func display(_ viewModel: QuizAnswerPresentableModel) {
        tableModel = viewModel.answer
    }
    
    func display(_ viewModel: QuizLoadingPresentableModel) {
        if viewModel.isLoading {
            self.present(LoadingViewController.shared, animated: false)
        } else {
            self.dismiss(animated: false, completion: nil)
        }
    }
    
    func display(_ viewModel: QuizErrorPresentableModel) {
        let retryButton = UIAlertAction(title: viewModel.retry, style: .default, handler: { _ in self.delegate?.didRequestLoading() })
        alertWithTitle(viewModel.message, message: nil, action: retryButton)
    }
    
    func display(_ viewModel: QuizResultPresentableModel) {                
        let retryButton = UIAlertAction(title: viewModel.retry, style: .default, handler: { _ in /*self.delegate?.didClickStatusButton()*/ })
        alertWithTitle(viewModel.title, message: viewModel.message, action: retryButton)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = tableModel[indexPath.row]
        return cell
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
}
