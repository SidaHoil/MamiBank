//
//  ViewState.swift
//  MamiBank
//
//  Created by Hoil Sida on 14/11/25.
//

import Foundation

enum ViewState<Value: Equatable>: Equatable {
    case idle
    case loading
    case success(Value)
    case failure(String)
}
