//
//  InputView.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit
import SwiftHelperInit

class CustomInputView: CustomBaseView {
    
    private let keyboardType: UIKeyboardType
    
    init(title: String, placeHolder: String, keyboardType: UIKeyboardType, rightView: UIView?) {
        self.keyboardType = keyboardType
        super.init(title: title, placeHolder: placeHolder, rightView: rightView)
        setup()
    }
    
    override init(frame: CGRect) {
        self.keyboardType = .default
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.keyboardType = .default
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {

        label.textColor = .label
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubViewWithConstraints(label, top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        
        let textFieldBgView = UIView()
        textFieldBgView.clipsToBounds = true
        textFieldBgView.layer.cornerRadius = 8
        textFieldBgView.layer.borderWidth = 0.2
        textFieldBgView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldBgView.backgroundColor = .secondarySystemBackground
        textFieldBgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(textFieldBgView)
        _ = textFieldBgView.anchor(top: label.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 0, height: 45))
        
        textField.borderStyle = .none
        textField.keyboardType = keyboardType
        textField.placeholder = placeHolder
        textField.rightView = rightView
        textField.rightViewMode = rightView == nil ? .never : .always
        textField.translatesAutoresizingMaskIntoConstraints = false
        textFieldBgView.addSubview(textField)
        _ = textField.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(top: 0, left: 8, bottom: 0, right: 8), size: .init(width: 0, height: 45))
        textField.centerYInSuperview()
        
    }
    
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
     textFieldBgView.layer.borderColor = UIColor.primary.cgColor
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
     textFieldBgView.layer.borderColor = UIColor.lightGray.cgColor // Revert border color when editing ends
     }*/
}
