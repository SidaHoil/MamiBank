//
//  CustomBaseView.swift
//  MamiBank
//
//  Created by Hoil Sida on 10/11/25.
//

import UIKit

class CustomBaseView: UIView {
    lazy var title: String? = nil
    lazy var placeHolder: String? = nil
    lazy var rightView: UIView? = nil
    lazy var label = UILabel()
    lazy var textField = UITextField()
    
    init(title: String, placeHolder: String?, rightView: UIView?) {
        super.init(frame: .zero)
        self.title = title
        self.placeHolder = placeHolder
        self.rightView = rightView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
