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

class QuizViewController: UIViewController, QuizAnswerView, QuizLoadingView, QuizStatusView, QuizErrorView, QuizQuestionView, QuizCounterView, QuizAnswerCountView, QuizResultView, UITableViewDataSource {
    var delegate: QuizViewControllerDelegate?
    
    @IBOutlet private(set) public var tableView: UITableView!
    @IBOutlet private(set) public var questionLabel: UILabel!
    @IBOutlet private(set) public var statusButton: UIButton!
    @IBOutlet private(set) public var counterLabel: UILabel!
    @IBOutlet private(set) public var answerCountLabel: UILabel!
    
    var tableModel = [String]() {
        didSet { tableView.reloadData() }
    }
                    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate?.didRequestLoading()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    @IBAction func didTapStateButton() {
        delegate?.didClickStatusButton()
    }
    
    func display(_ viewModel: QuizAnswerViewModel) {
        tableModel = viewModel.answer
    }
    
    func display(_ viewModel: QuizLoadingViewModel) {
        if viewModel.isLoading {
            self.present(LoadingViewController.shared, animated: true)
        } else {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    func display(_ viewModel: QuizStatusViewModel) {
        statusButton.setTitle(viewModel.status, for: .normal)
    }
    
    func display(_ viewModel: QuizQuestionViewModel) {
        questionLabel.text = viewModel.question
    }
    
    func display(_ viewModel: QuizCounterViewModel) {
        counterLabel.text = viewModel.seconds
    }
    
    func display(_ viewModel: QuizAnswerCountViewModel) {
        answerCountLabel.text = viewModel.answerCount
    }
    
    func display(_ viewModel: QuizErrorViewModel) {
        
    }
    
    func display(_ viewModel: QuizResultViewModel) {
        let alert = UIAlertController(title: viewModel.title, message: viewModel.message, preferredStyle: .alert)
        let yesButton = UIAlertAction(title: viewModel.retry, style: .default, handler: nil)
        alert.addAction(yesButton)        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = tableModel[indexPath.row]
        return cell
    }
}

extension QuizViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        delegate?.didTapNewAnswer(text)
        textField.text = ""
        return true
    }
}
