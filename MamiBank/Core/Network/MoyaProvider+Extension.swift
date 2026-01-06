//
//  MoyaProvider.swift
//  MamiBank
//
//  Created by Hoil Sida on 14/11/25.
//

import Moya
extension MoyaProvider {
    func asyncRequest(_ target: Target) async throws -> Response {
        try await withCheckedThrowingContinuation {[weak self] continuation in
            guard let self = self else { return }
            self.request(target) { result in
                switch result {
                case .success(let response):
                    continuation.resume(returning: response)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
