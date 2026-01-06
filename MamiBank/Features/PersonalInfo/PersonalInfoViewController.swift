//
//  PersonalInfoViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 24/10/25.
//

import UIKit
import SwiftHelperInit

class PersonalInfoViewController: BaseViewController {
    lazy var fullnameView = CustomInputView(title: "full_name".translate, placeHolder: "first_name_last_name".translate, keyboardType: .default, rightView: nil)
    
    lazy var dateView: CustomDatePickerView = CustomDatePickerView(title: "date_of_birth".translate, placeHolder: "DD MM YYYY")
    
    lazy var genderView = CustomDropdownView(title: "gender".translate, placeHolder: "select_an_option".translate, items: ["female".translate, "male".translate]) { item in
        return item
    }
    
    lazy var placeOfBirthView = CustomInputView(title: "place_of_birth".translate, placeHolder: "input_place_of_birth".translate, keyboardType: .default, rightView: nil)
    
    lazy var currentAddressView = CustomInputView(title: "current_address".translate, placeHolder: "input_current_address".translate, keyboardType: .default, rightView: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        hideKeyboardWhenTapAround()
        setupKeyboardNotifications()
        
    }
    
    @MainActor
    deinit{
        removeNotification()
    }
    
    func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubViewWithConstraints(
            contentView,
            top: scrollView.contentLayoutGuide.topAnchor,
            leading: scrollView.contentLayoutGuide.leadingAnchor,
            bottom: scrollView.contentLayoutGuide.bottomAnchor,
            trailing: scrollView.contentLayoutGuide.trailingAnchor)
        
        contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor).isActive = true
        
        let imageView = UIImageView(named: "personal_info", contentMode: .scaleAspectFit)
        let stackView = UIStackView(subViews: [
            imageView,
            UILabel(text: "personal_information_setup".translate, font: .boldSystemFont(ofSize: 20), textAlignment: .center),
            UIView(height: 20),
            fullnameView,
            dateView,
            genderView,
            placeOfBirthView,
            currentAddressView,
            UIView(height: 20),
            UIButton(title: "submit".translate, style: .init(textColor: .white, backgroundColor: .primary), corner: .init(radius: 10, color: .lightText, width: 0.2), height: 45, onTap: .init(target: self, action: #selector(sumitAction))),
            UIView(height: 250)
        ], axis: .vertical, spacing: 10)
        
        contentView.addSubViewToFill(stackView, padding: .init(horizontal: 16))
        // contentView.addSubViewWithConstraints(stackView, top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: contentView., trailing: contentView.trailingAnchor,padding: .init(horizontal: 16))
        // stackView.centerYInSuperview()
        imageView.setSize(width: view.frame.width * 0.5, height: view.frame.width/2.5)
       // scrollView.keyboardDismissMode = .interactive
    }
    
    @objc private func sumitAction() {
        
//        print(fullnameView.textField.text)
//        print(dateView.textField.text)
//        print(genderView.selectedItem)
//        print(placeOfBirthView.textField.text)
//        print(currentAddressView.textField.text)
    }
}
