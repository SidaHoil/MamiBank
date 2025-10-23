//
//  RegisterViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 23/10/25.
//

import UIKit
import SwiftHelperInit

class RegisterViewController: BaseViewController {

    private lazy var phoneView = InputView(label: "phone_number".translate, placeHolder: "000 000 000", keyboardType: .phonePad, rightView: nil)
    
    private lazy var registerButton = UIButton(title: "register".translate, style: .init(textColor: .white, backgroundColor: .primary,font: .boldSystemFont(ofSize: 16)), corner: .init(radius: 8, color: .gray, width: 1), height: 45, onTap: .init(target: self, action: #selector(registerAction)))
    
    
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
    
    private func setupUI(){
        view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        
        let welcomeLabel = UILabel(text: "welcome_to_mami_bank".translate,font: .boldSystemFont(ofSize: 30),numberOfLines: 1, textAlignment: .center)
        
        let imageView = UIImageView(named: "digital-currency", contentMode: .scaleAspectFit)
        
        let stackView = UIStackView(subViews: [
            imageView,
            welcomeLabel,
            UIView(height: 10),
            phoneView,
            registerButton
        ],axis: .vertical, spacing: 20)
        
        view.addSubViewWithConstraints(stackView, top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.centerYInSuperview()
        
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/3.0).isActive = true
        
    }
    
    @objc private func registerAction(){
        
    }
}
