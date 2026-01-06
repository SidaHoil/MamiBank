//
//  ViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit
import SwiftHelperInit
import LocalAuthentication
import Combine

class LoginViewController: BaseViewController {
    
    private lazy var isSowPwd = false
    
    private lazy var faceidImageView = UIImageView(image: UIImage(systemName: "faceid"), contentMode: .scaleAspectFit)
    
    private lazy var eyeImageView = UIImageView(image: UIImage(systemName: "eye"), contentMode: .scaleAspectFit)
    
    private lazy var phoneView = CustomInputView(
        title: "phone_number".translate,
        placeHolder: "09645678",
        keyboardType: .phonePad,
        rightView: faceidImageView)
    
    private lazy var passwordView = CustomInputView(
        title: "password".translate,
        placeHolder: "please_input_password".translate,
        keyboardType: .default,
        rightView: eyeImageView)
    
    private lazy var loginButton = UIButton(
        title: "login".translate,
        style: .init(textColor: .white, backgroundColor: .primary),
        corner: .init(radius: 10, color: .gray, width: 1),
        height: 45,
        onTap: .init(target: self, action: #selector(loginAction)))
    
    private lazy var registerButton = UIButton(
        title: "register".translate,
        style: .init(textColor: .primary, backgroundColor: .clear),
        onTap: .init(target: self, action: #selector(registerAction)))
    
    private let viewModel: LoginViewModel
    private var cancellables = Set<AnyCancellable>()
    private let loadingView = LoadingView()
    
    init(viewModel: LoginViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        // super.init()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupUI()
        hideKeyboardWhenTapAround()
        setupKeyboardNotifications()
        bindViewModel()
    }
    
    @MainActor
    deinit{
        removeNotification()
    }
    
    private func setupUI() {
        passwordView.textField.isSecureTextEntry = !isSowPwd
        faceidImageView.tintColor = .primary
        faceidImageView.addTarget(target: self, action: #selector(faceIdAction))
        
        eyeImageView.tintColor = .primary
        eyeImageView.addTarget(target: self, action: #selector(eyeAction))
        
        let imageView = UIImageView(named: "welcome", contentMode: .scaleAspectFit)
        
        let welcomeLabel = UILabel(text: "welcome_to_mami_bank".translate, font: .boldSystemFont(ofSize: 30), numberOfLines: 1, textAlignment: .center)
        
        let footerLabel = UILabel(text: "do_not_have_account".translate, textAlignment: .right)
        
        let footerStack = UIStackView(subViews: [
            UIView(),
            footerLabel,
            registerButton
        ], distribution: .fill, alignment: .center, axis: .horizontal, spacing: 10)
        
        let stackView = UIStackView(subViews: [
            imageView,
            UIView(height: 30),
            welcomeLabel,
            UIView(height: 40),
            phoneView,
            UIView(height: 20),
            passwordView,
            UIView(height: 30),
            loginButton,
            footerStack
        ], distribution: .fill, alignment: .fill, axis: .vertical, spacing: 0)
        
        view.addSubViewWithConstraints(stackView, top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.centerYInSuperview()
        
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/3.0).isActive = true
        
        faceidImageView.setSize(width: 28, height: 28)
        eyeImageView.setSize(width: 28, height: 28)
    }
    
    @objc private func loginAction() {
        guard let phoneNumber = phoneView.textField.text, !phoneNumber.isEmpty else {
            AlertMessage.shared.show(title: "data_missing".translate, message: "please_input_phone_number".translate) { [weak self] in
                self?.phoneView.textField.becomeFirstResponder()
            }
            return
        }
        
        guard let password = passwordView.textField.text, !password.isEmpty else {
            AlertMessage.shared.show(title: "data_missing".translate, message: "please_input_password".translate) { [weak self] in
                self?.passwordView.textField.becomeFirstResponder()
            }
            return
        }
        
        viewModel.login(phone: phoneNumber, password: password)
        
        // self.navigationController?.pushViewController(HomeViewController(), animated: true)
        // print("Login with phone: \(phoneNumber), password: \(password)")
    }
    
    @objc private func registerAction() {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
    
    @objc private func faceIdAction() {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Authenticate to log in to your account"
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        print("✅ Face ID / Touch ID success")
                    } else {
                        print("Authentication failed: \(authenticationError?.localizedDescription ?? "Unknown error")")
                    }
                }
            }
        } else {
            print("⚠️ Biometric authentication not available: \(error?.localizedDescription ?? "Unknown reason")")
        }
    }
    
    @objc private func eyeAction() {
        if isSowPwd {
            eyeImageView.image = UIImage(systemName: "eye")
        } else {
            eyeImageView.image = UIImage(systemName: "eye.slash")
        }
        passwordView.textField.isSecureTextEntry = isSowPwd
        isSowPwd = !isSowPwd
        passwordView.layoutIfNeeded()
        
    }
    
    private func bindViewModel() {
        viewModel.$state
            .sink { [weak self] state in
                guard let self else { return }
                switch state {
                case .idle:
                    self.loadingView.hide()
                    
                case .loading:
                    self.loadingView.show(on: self.view)
                    
                case .success(let response):
                    self.loadingView.hide()
                    AlertMessage.shared.show(title: "Success", message: "Token: \(response.token ?? "")")
                case .failure(let sms):
                    self.loadingView.hide()
                    AlertMessage.shared.show(title: "Error", message: sms)
                }
            }
            .store(in: &cancellables)
       
    }
}
