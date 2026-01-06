//
//  LoginViewModel.swift
//  MamiBank
//
//  Created by Hoil Sida on 22/10/25.
//
import Foundation
import Combine
import Network

class LoginViewModel: ObservableObject {
    @Published private(set) var state: ViewState<LoginResponseModel> = .idle
    
    private let repo: LoginRepositoryProtocol
    private var monitor: NWPathMonitor?
    
    private(set) var isConnected: Bool = true
    
    init(repo: LoginRepositoryProtocol) {
        self.repo = repo
        startNetworkMonitoring()
    }
    
    func login(phone: String, password: String) {
        guard !phone.isEmpty, !password.isEmpty else {
            state = .failure("Phone & password required.")
            return
        }
        
        guard isConnected else {
            state = .failure("No internet connection.")
            return
        }
        
        state = .loading
        
        Task {
            do {
                let result = try await repo.login(phone: phone, password: password)
                state = .success(result)
            } catch {
                // "The given data was not valid JSON."
                // The data couldn't be read because it isn't in the correct format
                state = .failure(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Network Monitor
    private func startNetworkMonitoring() {
        monitor = NWPathMonitor()
        let queue = DispatchQueue(label: "NetworkMonitor")
        monitor?.pathUpdateHandler = { [weak self] path in
            DispatchQueue.main.async {
                self?.isConnected = (path.status == .satisfied)
            }
        }
        monitor?.start(queue: queue)
    }
    
    deinit {
        monitor?.cancel()
    }
}
