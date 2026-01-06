//
//  APIProvider.swift
//  MamiBank
//
//  Created by Hoil Sida on 12/11/25.
//
import Moya

final class APIProvider {
    static let shared = APIProvider()
    
    private let provider: MoyaProvider<API>
    
    init(isMock: Bool = EnvironmentConfig.shared.isMock) {
        if isMock {
            // provider = MoyaProvider<API>(stubClosure: MoyaProvider.delayedStub(0.6))
            provider = MoyaProvider<API>(stubClosure: { _ in .immediate })
        } else {
            provider = MoyaProvider<API>()
        }
    }
    
    func request<T: Decodable>(_ target: API, type: T.Type, completion: @escaping (Result<T, Error>) -> Void) {
        provider.request(target) { result in
            switch result {
            case .success(let response):
                do {
                    let model = try JSONDecoder().decode(T.self, from: response.data)
                    completion(.success(model))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
