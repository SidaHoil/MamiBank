//
//  AppFonts.swift
//  MamiBank
//
//  Created by Hoil Sida on 22/10/25.
//

import UIKit
import ObjectiveC

struct AppFonts {
    static var shared = AppFonts()
    
    let notoSanBlack = "NotoSansKhmer-Black"
    let notoSanBold = "NotoSansKhmer-Bold"
    let notoSanExtraBold = "NotoSansKhmer-ExtraBold"
    let notoSanExtraLight = "NotoSansKhmer-ExtraLight"
    let notoSanLight = "NotoSansKhmer-Light"
    let notoSanMedium = "NotoSansKhmer-Medium"
    let notoSanRegular = "NotoSansKhmer-Regular"
    let notoSanSemoBold = "NotoSansKhmer-SemiBold"
}

extension UIFont{
    static func overrideFont() {
        guard self == UIFont.self else { return }
        
        if let systemFontMethod = class_getClassMethod(self, #selector(systemFont(ofSize:))),
           let mySystemFontMethod = class_getClassMethod(self, #selector(mySystemFont(ofSize:))) {
            method_exchangeImplementations(systemFontMethod, mySystemFontMethod)
        }
    }
    
    @objc class func mySystemFont(ofSize size: CGFloat) -> UIFont {
        return UIFont(name: AppFonts.shared.notoSanRegular, size: size)!
    }
}
