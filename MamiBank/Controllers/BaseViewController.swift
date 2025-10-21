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
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
