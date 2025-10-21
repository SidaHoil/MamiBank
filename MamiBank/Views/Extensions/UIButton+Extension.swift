//
//  UIButton+Extension.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit

struct ButtonStyle{
    var textColor: UIColor
    var backgroundColor: UIColor
    var font: UIFont
}

struct CornerStyle {
    var radius: CGFloat
    var color: UIColor
    var width: CGFloat
}
struct ButtonTarget{
    var target: Any
    var action: Selector
    var controlEvents: UIControl.Event = .touchUpInside
}
//font
extension UIButton {
    convenience init(title: String) {
        self.init(type: .system)
        setTitle(title, for: .normal)
    }
    convenience init(title: String, font: UIFont) {
        self.init(type: .system)
        setTitle(title, for: .normal)
        self.titleLabel?.font = font
    }
    
    convenience init(title: String, font: UIFont, onTap: ButtonTarget) {
        self.init(title: title, font: font)
        self.addTarget(onTap.target, action: onTap.action, for: onTap.controlEvents)
    }
    
    convenience init(title: String, style: ButtonStyle, onTap: ButtonTarget) {
        self.init(title: title, font: style.font, onTap: onTap)
        setTitleColor(style.textColor, for: .normal)
        self.backgroundColor = style.backgroundColor
    }
    
    convenience init(title: String, style: ButtonStyle, corner: CornerStyle, height: CGFloat, onTap: ButtonTarget) {
        self.init(title: title, style: style, onTap: onTap)
        
        self.clipsToBounds = true
        self.layer.cornerRadius = corner.radius
        self.layer.borderColor = (corner.color).cgColor
        self.layer.borderWidth = corner.width
        self.constrainHeight(height)
    }
}
