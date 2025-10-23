//
//  String+Extension.swift
//  MamiBank
//
//  Created by Hoil Sida on 22/10/25.
//
import Foundation

extension String {
    var translate: String {
        NSLocalizedString(self, comment: "")
    }
}

