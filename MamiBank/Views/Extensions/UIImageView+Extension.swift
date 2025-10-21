//
//  UIImageView+Extension.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//

import UIKit

extension UIImageView{
    
    convenience init(named: String, contentMode: UIView.ContentMode){
        self.init(image: UIImage(named: named))
        self.contentMode = contentMode
    }
}
