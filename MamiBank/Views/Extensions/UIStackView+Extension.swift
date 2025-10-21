//
//  UIStackView+Extension.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit

extension UIStackView{
    
    convenience init(subViews: [UIView], axis: NSLayoutConstraint.Axis = .horizontal, spacing: CGFloat  = 0) {
        self.init(arrangedSubviews: subViews)
        self.axis = axis
        self.spacing = spacing
    }
    
    convenience init(
        subViews: [UIView],
        distribution: Distribution = .fill,
        alignment: UIStackView.Alignment = .fill,
        axis: NSLayoutConstraint.Axis = .horizontal,
        spacing: CGFloat = 0
    ) {
        self.init(arrangedSubviews: subViews)
        self.distribution = distribution
        self.alignment = alignment
        self.axis = axis
        self.spacing = spacing
    }
}
