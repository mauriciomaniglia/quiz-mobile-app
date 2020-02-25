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
    func didTapNewAnswer(_ answer: String)
    func didClickStatusButton()
}

class QuizViewController: UIViewController, QuizAnswerView, QuizLoadingView, QuizStatusView, QuizErrorView, QuizCounterView, QuizAnswerCountView, QuizResultView, UITableViewDataSource {
    var delegate: QuizViewControllerDelegate?
    
    @IBOutlet private(set) public var tableView: UITableView!
    @IBOutlet private(set) public var statusButton: UIButton!
    @IBOutlet private(set) public var counterLabel: UILabel!
    @IBOutlet private(set) public var answerCountLabel: UILabel!
    @IBOutlet weak var headerContainer: UIView!
    
    var quizHeaderController: QuizHeaderViewController!
    
    var tableModel = [String]() {
        didSet { tableView.reloadData() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didRequestLoading()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.keyboardDismissMode = .onDrag
        
        addHeaderContent()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        view.endEditing(true)
    }
    
    @IBAction func didTapStateButton() {
        delegate?.didClickStatusButton()
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
    
    func display(_ viewModel: QuizStatusPresentableModel) {
        statusButton.setTitle(viewModel.status, for: .normal)
    }
    
    func display(_ viewModel: QuizCounterPresentableModel) {
        counterLabel.text = viewModel.seconds
    }
    
    func display(_ viewModel: QuizAnswerCountPresentableModel) {
        answerCountLabel.text = viewModel.answerCount
    }
    
    func display(_ viewModel: QuizErrorPresentableModel) {
        let retryButton = UIAlertAction(title: viewModel.retry, style: .default, handler: { _ in self.delegate?.didRequestLoading() })
        alertWithTitle(viewModel.message, message: nil, action: retryButton)
    }
    
    func display(_ viewModel: QuizResultPresentableModel) {                
        let retryButton = UIAlertAction(title: viewModel.retry, style: .default, handler: { _ in self.delegate?.didClickStatusButton() })
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
}
