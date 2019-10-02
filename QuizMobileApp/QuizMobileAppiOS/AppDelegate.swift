//
//  AppDelegate.swift
//  QuizMobileAppiOS
//
//  Created by Mauricio Cesar Maniglia Junior on 02/10/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit
import QuizMobileApp

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        let client = URLSessionHTTPClient(session: URLSession(configuration: .default))
        let url = URL(string: "https://codechallenge.arctouch.com/quiz/1")!
        let questionLoader = RemoteQuestionLoader(url: url, store: client)
        let initialViewController = QuizUIComposer.quizComposedWith(questionLoader: questionLoader)

        self.window?.rootViewController = initialViewController
        self.window?.makeKeyAndVisible()
        
        return true
    }

}

