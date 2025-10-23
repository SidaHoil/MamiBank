//
//  BaseViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit

class BaseViewController: UIViewController {
    
    func hideKeyboardWhenTapAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func removeNotification(){
        NotificationCenter.default.removeObserver(self)
    }
    
    func setupKeyboardNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow(notification:)),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide(notification:)),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        let keyboardHeight = keyboardFrame.height
        let bottomInset = keyboardHeight - view.safeAreaInsets.bottom
        
        
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = -bottomInset / 2  // You can adjust division value if needed
        }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        UIView.animate(withDuration: 0.3) {
            self.view.frame.origin.y = 0
        }
    }
}
