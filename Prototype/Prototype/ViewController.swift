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
    @IBOutlet var startButton: UIButton!
    @IBOutlet var tableView: UITableView!
    
    var isKeyboardVisible = false
    
    var seconds = 20
    var timer = Timer()
    var isTimerRunning = false
    var resumeTapped = false
    
    var data = [String]()
    
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
            runTimer()
            self.resumeTapped = true
            self.startButton.setTitle("Reset", for: .normal)
            textfield.isUserInteractionEnabled = true
        } else {
            self.startButton.setTitle("Start", for: .normal)
            resetButtonTapped()
            self.resumeTapped = false
            textfield.isUserInteractionEnabled = false
            data = []
            tableView.reloadData()
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
        let alert = UIAlertController(title: "Time finished", message: "Sorry, time is up! You got 32 out of 50 answers.", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Try Again", style: .default, handler: nil)
        alert.addAction(yesButton)
        
        present(alert, animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textfield.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        textfield.isUserInteractionEnabled = false
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            self.present(self.loadingViewController(), animated: true)
        })
        
        let paddingView: UIView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 43))
        textfield.leftView = paddingView
        textfield.leftViewMode = .always
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
        guard isKeyboardVisible == true else { return }
        
        UIView.animate(withDuration: 2.0, animations: {
            self.isKeyboardVisible = false
            self.footerContainerBottomConstraint.constant -= self.keyboardHeight(notification) ?? 0
            self.buttonBottomConstraint.constant -= self.keyboardHeight(notification) ?? 0
        })
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

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text, text.isEmpty == false {
            let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
            data.append(trimmedText)
            tableView.reloadData()
            textField.text = ""
        }
        return true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as UITableViewCell
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }
}

