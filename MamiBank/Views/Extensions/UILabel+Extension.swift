//
//  UILabel+Extension.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit

extension UILabel{
    
    convenience init(text: String) {
        self.init()
        self.text = text
    }
    
    convenience init(text: String, textColor: UIColor = .label,font: UIFont = .systemFont(ofSize: 14), textAlignment: NSTextAlignment = .natural) {
        self.init()
        self.text = text
        self.textColor = textColor
        self.font = font
        self.textAlignment = textAlignment
    }
}
