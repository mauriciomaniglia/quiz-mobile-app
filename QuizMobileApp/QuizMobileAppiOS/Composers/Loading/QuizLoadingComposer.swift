//
//  QuizLoadingComposer.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 11/04/20.
//  Copyright © 2020 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit

final class QuizLoadingComposer {
    private static var rootViewController: UIViewController? = {
        return UIApplication.shared.keyWindow!.rootViewController
    }()
    
    private init() {}
    
    private static func loadingViewController() -> UIViewController {
        let storyboard = UIStoryboard(name: "QuizLoading", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: "QuizLoadingViewController")
        return loadingViewController
    }
    
    static func showLoading() {
        rootViewController?.present(loadingViewController(), animated: false)
    }
    
    static func hideLoading() {
        self.rootViewController?.dismiss(animated: false, completion: nil)
    }
}
