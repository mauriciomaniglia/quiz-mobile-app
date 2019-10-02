//
//  LoadingViewController.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit

final class LoadingViewController: UIViewController {
    static let shared = loadingController()

    @IBOutlet private(set) public var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
    }
    
     private static func loadingController() -> LoadingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        return loadingViewController
    }

}
