//
//  ViewController.swift
//  Prototype
//
//  Created by Mauricio Cesar Maniglia Junior on 27/09/19.
//  Copyright © 2019 Mauricio Cesar Maniglia Junior. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var footerContainerBottomConstraint: NSLayoutConstraint!
    @IBOutlet var buttonBottomConstraint: NSLayoutConstraint!
    @IBOutlet var timerLabel: UILabel!
    @IBOutlet var textfield: UITextField!
    
    var isKeyboardVisible = false
    
    var seconds = 20
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    func runTimer() {
         timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        if seconds < 1 {
             timer.invalidate()
             showAlertController()
        } else {
             seconds -= 1
             timerLabel.text = timeString(time: TimeInterval(seconds))
        }
    }
    
    @IBAction func didStartGame() {
        if self.resumeTapped == false {
             timer.invalidate()
             self.resumeTapped = true
        } else {
             runTimer()
             self.resumeTapped = false
        }
    }
    
    func resetButtonTapped() {
         timer.invalidate()
         seconds = 60
         timerLabel.text = timeString(time: TimeInterval(seconds))
    }
    
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func showAlertController() {
        let alert = UIAlertController(title: "Time finished", message: "Sorry, time is up!", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes, please", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            print("you pressed Yes, please button")
        })
        alert.addAction(yesButton)
        
        present(alert, animated: true)
    }
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.present(self.loadingViewController(), animated: true)
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillShow(notification:NSNotification) {
        guard !UIDevice.current.orientation.isLandscape else { return }
        guard isKeyboardVisible == false else { return }
        
        UIView.animate(withDuration: 2.0, animations: {
            self.isKeyboardVisible = true
            self.footerContainerBottomConstraint.constant += self.keyboardHeight(notification) ?? 0
            self.buttonBottomConstraint.constant += self.keyboardHeight(notification) ?? 0
        })
    }
     
    @objc func keyboardWillHide(notification:NSNotification) {
        UIView.animate(withDuration: 2.0, animations: {
            self.isKeyboardVisible = false
            self.footerContainerBottomConstraint.constant -= self.keyboardHeight(notification) ?? 0
            self.buttonBottomConstraint.constant -= self.keyboardHeight(notification) ?? 0
        })
    }
    
    func adjustingHeight(show:Bool, notification:NSNotification) {
       
    }
    
    func keyboardHeight(_ notification: NSNotification) -> CGFloat? {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            return keyboardRectangle.height
        }
        
        return nil
    }
    
    func loadingViewController() -> LoadingViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loadingViewController = storyboard.instantiateViewController(withIdentifier: "LoadingViewController") as! LoadingViewController
        return loadingViewController
    }
}

