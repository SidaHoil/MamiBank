//
//  OTPViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 22/10/25.
//

import UIKit
import SwiftHelperInit

class OTPViewController: BaseViewController, UITextFieldDelegate {
    lazy var phoneNumber: String = "6789"
    private var otpTextFields: [UITextField] = []
    private let otpLength = 5
    
    init(phoneNumber: String) {
        super.init(nibName: nil, bundle: nil)
        self.phoneNumber = phoneNumber
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.phoneNumber = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupKeyboardNotifications()
    }
    
    @MainActor
    deinit{
        removeNotification()
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        let imageView = UIImageView(image: UIImage(named: "message-sent"), contentMode: .scaleAspectFit)
        let titleLabel = UILabel(text: "enter_verification_code".translate,font: .systemFont(ofSize: 30),textAlignment: .center)
        
        
        let startIndex = phoneNumber.index(phoneNumber.endIndex, offsetBy: -min(2, phoneNumber.count))
        let last = phoneNumber[startIndex...]
        
        let descriptionLabel = UILabel(text: "we_are_automatically_delivering_a_sms_send_to_your_mobile_number".translate + "******\(last)" ,numberOfLines: 3, textAlignment: .center)
        
        let resendLabel = UILabel(text: "do_not_receive_otp_code".translate,textAlignment: .center)
        let resendButton = UIButton(title: "resend_code".translate, style: .init(textColor: .primary, backgroundColor: .clear), onTap: .init(target: self, action: #selector(resendAction)))
        
        let verifyButton = UIButton(title: "verify".translate, style: .init(textColor: .white, backgroundColor: .primary, font: .boldSystemFont(ofSize: 16)), corner: .init(radius: 10, color: .lightGray, width: 0.2), height: 45, onTap: .init(target: self, action: #selector(verifyAction)))
        
        let stackView = UIStackView(subViews: [
            imageView,
            titleLabel,
            descriptionLabel,
            UIStackView(subViews:[
                UIView(width: 20),
                setupOTPTextFields(),
                UIView(width: 20),
            ],axis: .vertical,spacing: 0),
            UIView(height: 5),
            UIStackView(subViews:[
                resendLabel,
                resendButton,
            ],axis: .vertical,spacing: 0),
            verifyButton
        ],axis: .vertical,spacing: 20)
        
        view.addSubViewWithConstraints(stackView, top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 0, left: 16, bottom: 0, right: 16))
        stackView.centerYInSuperview()
        
        imageView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0/3.0).isActive = true
    }
    
    private func setupOTPTextFields() -> UIView{
        
        for i in 0..<otpLength {
            let textField = createTextField(tag: i)
            otpTextFields.append(textField)
        }
        let stackView = UIStackView(subViews: otpTextFields,distribution: .fillEqually,alignment: .center,axis: .horizontal,spacing: 16)
        return stackView
    }
    
    private func createTextField(tag: Int) -> UITextField {
        let tf = UITextField()
        tf.delegate = self
        tf.tag = tag
        tf.textAlignment = .center
        tf.font = .boldSystemFont(ofSize: 24)
        tf.keyboardType = .numberPad
        tf.backgroundColor = .systemGray6
        tf.layer.cornerRadius = 10
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.systemGray3.cgColor
        tf.setSize(width: 50, height: 60)
        
        // focus color change
        tf.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        return tf
    }
    
    @objc private func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text, !text.isEmpty else { return }
        
        // Move to next
        if text.count == 1 {
            let nextTag = textField.tag + 1
            if nextTag < otpLength {
                otpTextFields[nextTag].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                verifyAction()
            }
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // only allow 1 digit
        if string.count > 1 { return false }
        
        // replace text
        textField.text = string
        if !string.isEmpty {
            let nextTag = textField.tag + 1
            if nextTag < otpLength {
                otpTextFields[nextTag].becomeFirstResponder()
            } else {
                textField.resignFirstResponder()
                verifyAction()
            }
            return false
        }
        return true
    }
    
    
    @objc private func resendAction(){
        
    }
    
    @objc private func verifyAction(){
        let otpCode = otpTextFields.compactMap { $0.text }.joined()
        if otpCode.isEmpty{
            AlertMessage.shared.show(title: "data_missing".translate, message: "please_input_otp_code".translate)
        }else{
            print("OTP Entered: \(otpCode)")
            
            // Example: Show alert
            let alert = UIAlertController(title: "Entered OTP", message: otpCode, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { [weak self] _ in
                self?.navigationController?.pushViewController(SelfieViewController(), animated: true)
            }))
            present(alert, animated: true)
        }
        
    }
}
