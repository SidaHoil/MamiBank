//
//  CustomDatePickerView.swift
//  MamiBank
//
//  Created by Hoil Sida on 10/11/25.
//

import UIKit
import SwiftHelperInit

class CustomDatePickerView: CustomBaseView {
    lazy private var datePicker = UIDatePicker()
    
    init(title: String, placeHolder: String?) {
        super.init(title: title, placeHolder: placeHolder, rightView: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI() {
        label.text = title
        let imageView = UIImageView(image: UIImage(named: "calendar"), contentMode: .scaleAspectFit)
        textField.rightView = imageView
        textField.borderStyle = .none
        textField.placeholder = placeHolder
        textField.rightViewMode = .always
        
        let textFieldBgView = UIView(style: .init(radius: 8, color: .lightGray, width: 0.2))
        textFieldBgView.clipsToBounds = true
        textFieldBgView.backgroundColor = .secondarySystemBackground
        
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .wheels
        
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([flexSpace, doneButton], animated: true)
        
        textField.inputAccessoryView = toolbar
        textField.inputView = datePicker
        
        let stackView = UIStackView(subViews: [
            label,
            textFieldBgView
        ], distribution: .fillProportionally, alignment: .fill, axis: .vertical, spacing: 4)
        
        addSubViewToFill(stackView)
        textFieldBgView.addSubViewToFill(textField, padding: .init(horizontal: 8))
        textField.setSize(width: 0, height: 45)
        imageView.setSize(width: 25, height: 25)
    }
    
    @objc func donePressed() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        textField.text = formatter.string(from: datePicker.date)
        textField.resignFirstResponder()
    }
}
