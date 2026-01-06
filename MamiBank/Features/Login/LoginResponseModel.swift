//
//  LoginResponseModel.swift
//  MamiBank
//
//  Created by Hoil Sida on 13/11/25.
//

struct LoginResponseModel: Codable, Equatable {
    let status: String
    let message: String
    let token: String?
}
