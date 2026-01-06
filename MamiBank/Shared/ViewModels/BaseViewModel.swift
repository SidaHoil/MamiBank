//
//  BaseViewModel.swift
//  MamiBank
//
//  Created by Hoil Sida on 12/11/25.
//
import Foundation
import Moya

class BaseViewModel {
    private let plugin: PluginType = NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))
    // var state : Box<State?> = Box(nil)
    var provider = MoyaProvider<API>(plugins: [NetworkLoggerPlugin()])
    
    init() {
        provider = MoyaProvider<API>(plugins: [plugin])
    }
    
    func checkingResult(
        result: Result<Response, MoyaError>,
        onSuccess: (_ data: Any) -> Void,
        onError: (_ sms: String) -> Void) {
            switch result {
            case .success(let res):
                let code = res.statusCode
                print("Respone code: \(code)")
            case .failure(let error):
                print(error.errorDescription ?? "Error")
            }
    }
}
