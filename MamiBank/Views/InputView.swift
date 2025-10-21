//
//  InputView.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit

class InputView: UIView {
    let text: String
    let placeHolder: String
    let keyboardType: UIKeyboardType
    private let label = UILabel()
    let textField = UITextField()
    private let textFieldBgView = UIView()
    
    // Designated initializer
    init(text: String, placeHolder: String, keyboardType: UIKeyboardType) {
        self.text = text
        self.placeHolder = placeHolder
        self.keyboardType = keyboardType
        super.init(frame: .zero)
        setup()
    }
    
    // Optional convenience path if instantiated with frame directly
    override init(frame: CGRect) {
        self.text = ""
        self.placeHolder = ""
        self.keyboardType = .default
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        self.text = ""
        self.placeHolder = ""
        self.keyboardType = .default
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        label.textColor = .label
        textField.borderStyle = .none
        textField.keyboardType = .phonePad
        addSubview(label)
        
        textFieldBgView.clipsToBounds = true
        textFieldBgView.layer.cornerRadius = 8
        textFieldBgView.layer.borderWidth = 0.2
        textFieldBgView.layer.borderColor = UIColor.lightGray.cgColor
        textFieldBgView.backgroundColor = .secondarySystemBackground
        addSubview(textFieldBgView)
        textFieldBgView.anchor(top: label.bottomAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor,padding: .init(top: 10, left: 0, bottom: 0, right: 0),size: .init(width: 0, height: 45))
        
        
        textFieldBgView.addSubview(textField)
        // Configure content
        label.text = text
        textField.placeholder = placeHolder
        
        // Layout using your anchor helper (sets translatesAutoresizingMaskIntoConstraints = false)
        label.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor)
        textField.centerYAnchor.constraint(equalTo: textFieldBgView.centerYAnchor).isActive = true
        textField.anchor(top: nil, leading: textFieldBgView.leadingAnchor, bottom: nil, trailing: textFieldBgView.trailingAnchor,padding: .init(top: 0, left: 8, bottom: 0, right: 8),size: .init(width: 0, height: 45))
    }
    
    /*func textFieldDidBeginEditing(_ textField: UITextField) {
     textFieldBgView.layer.borderColor = UIColor.primary.cgColor
     }
     
     func textFieldDidEndEditing(_ textField: UITextField) {
     textFieldBgView.layer.borderColor = UIColor.lightGray.cgColor // Revert border color when editing ends
     }*/
}
