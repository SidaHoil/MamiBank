//
//  RegisterViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 23/10/25.
//

import UIKit
import SwiftHelperInit

class RegisterViewController: BaseViewController {

    private lazy var phoneView = CustomInputView(title: "phone_number".translate, placeHolder: "012 345 567", keyboardType: .phonePad, rightView: nil)
    
    private lazy var registerButton = UIButton(title: "register".translate, style: .init(textColor: .white, backgroundColor: .primary, font: .boldSystemFont(ofSize: 16)), corner: .init(radius: 8, color: .gray, width: 1), height: 45, onTap: .init(target: self, action: #selector(registerAction)))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        hideKeyboardWhenTapAround()
        setupKeyboardNotifications()
    }
    
    @MainActor
    deinit {
        removeNotification()
    }
        
    private func setupUI() {
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        
        let welcomeLabel = UILabel(text: "welcome_to_mami_bank".translate, font: .boldSystemFont(ofSize: 30), numberOfLines: 1, textAlignment: .center)
        
        let imageView = UIImageView(named: "digital-currency", contentMode: .scaleAspectFit)
        
        let footerLabel = UILabel(text: "already_have_account".translate, textAlignment: .right)
        
        let loginButton = UIButton(title: "login".translate, style: .init(textColor: .primary, backgroundColor: .clear), onTap: .init(target: self, action: #selector(loginAction)))
        
        let footerStack = UIStackView(subViews: [
            UIView(),
            footerLabel,
            loginButton
        ], distribution: .fill, alignment: .center, axis: .horizontal, spacing: 10)
        
        let stackView = UIStackView(subViews: [
            imageView,
            UIView(height: 30),
            welcomeLabel,
            UIView(height: 30),
            phoneView,
            UIView(height: 16),
            registerButton,
            footerStack
        ], axis: .vertical, spacing: 0)
        
        view.addSubViewWithConstraints(stackView, top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.centerYInSuperview()
        
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/3.0).isActive = true
        
    }
    
    @objc private func registerAction() {
        guard let phoneNumber = phoneView.textField.text, !phoneNumber.isEmpty else {
            AlertMessage.shared.show(title: "data_missing".translate, message: "please_input_password".translate) {[weak self] in
                self?.phoneView.textField.becomeFirstResponder()
            }
            return
        }
        
        // Pass the phone number into OTP screen
        self.navigationController?.pushViewController(OTPViewController(phoneNumber: phoneNumber), animated: true)
        print(phoneNumber)
    }
    
    @objc private func loginAction() {
        self.navigationController?.popViewController(animated: true)
    }
}
