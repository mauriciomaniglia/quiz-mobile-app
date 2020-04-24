//
//  QuizAnswerListViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 27/02/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

public final class QuizAnswerListViewController: UIViewController, UITableViewDataSource, QuizAnswerList {
    @IBOutlet private(set) public var tableView: UITableView!
    
    private let cellReuseIdentifier = "Cell"
    
    var tableModel = [String]() {
        didSet { tableView.reloadData() }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    public func display(_ presentableModel: QuizAnswerListPresentableModel) {
        tableModel = presentableModel.answer
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableModel.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as UITableViewCell
        cell.textLabel?.text = tableModel[indexPath.row]
        return cell
    }
}
