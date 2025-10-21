//
//  ViewController.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit

class ViewController: BaseViewController {

    let phoneView = InputView(text: "Phone number", placeHolder: "09645678", keyboardType: .phonePad)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(phoneView)
        setupUI()
        
    }
    
    
    func setupUI() {
        let imageView = UIImageView(named: "digital-currency", contentMode: .scaleAspectFit)
        
        let button = UIButton(title: "Login", style: .init(textColor: .white, backgroundColor: .primary,font: .boldSystemFont(ofSize: 16)), corner: .init(radius: 8, color: .gray, width: 1), height: 45, onTap: .init(target: self, action: #selector(loginAction)))
        
        
        let stackView = UIStackView(subViews: [
            imageView,
            UILabel(text: "Welcome to Mini Bank",textAlignment: .center),
            phoneView,
            button
        ], axis: .vertical, spacing: 8)
        
        view.addSubview(stackView)
        
        imageView.constrainHeight(view.frame.width/3)
        
        stackView.anchor(top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor,padding: .init(top: 16, left: 16, bottom: 0, right: 16))
        
        hideKeyboardWhenTapAround()
    }
    
    @objc func loginAction(){
        
    }


}

