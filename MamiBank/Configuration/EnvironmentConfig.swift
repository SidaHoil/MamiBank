//
//  EnvironmentConfig.swift
//  MamiBank
//
//  Created by Hoil Sida on 21/10/25.
//
import Foundation

protocol ConfigurationProtocol {
    var isLoggingEnabled: Bool { get }
    var analyticsKey: String { get }
    var firebasePath: String { get }
    
    var isDebugMenuEnabled: Bool { get }
    var environmentName: String { get }
    
    // Network settings
    var apiTimeout: TimeInterval { get }
    var maxRetryAttempts: Int { get }
    
    // Feature flags
    var isFeatureXEnabled: Bool { get }
    var isBetaFeaturesEnabled: Bool { get }
}

private struct DevConfiguration: ConfigurationProtocol {
    
    // General
    let isLoggingEnabled: Bool = true
    let analyticsKey: String = "DEV-ANALYTICS-KEY"
    var firebasePath: String {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Dev", ofType: "plist")!
        return filePath
    }
    
    let isDebugMenuEnabled: Bool = true
    let environmentName: String = "Development"
    
    // Network settings
    let apiTimeout: TimeInterval = 30.0
    let maxRetryAttempts: Int = 2
    
    // Feature flags
    let isFeatureXEnabled: Bool = true
    let isBetaFeaturesEnabled: Bool = true
}

private struct StagingConfiguration: ConfigurationProtocol {
    // General
    let isLoggingEnabled: Bool = true
    let analyticsKey: String = "STAGING-ANALYTICS-KEY"
    var firebasePath: String {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info-Staging", ofType: "plist")!
        return filePath
    }
    
    let isDebugMenuEnabled: Bool = true
    let environmentName: String = "Staging"
    
    // Network settings
    let apiTimeout: TimeInterval = 15.0
    let maxRetryAttempts: Int = 2
    
    // Feature flags
    let isFeatureXEnabled: Bool = true
    let isBetaFeaturesEnabled: Bool = false
}

private struct ProductionConfiguration: ConfigurationProtocol {
    // General
    let isLoggingEnabled: Bool = true
    let analyticsKey: String = "PROD-ANALYTICS-KEY"
    var firebasePath: String {
        let filePath = Bundle.main.path(forResource: "GoogleService-Info", ofType: "plist")!
        return filePath
    }
    
    let isDebugMenuEnabled: Bool = true
    let environmentName: String = "Production"
    
    // Network settings
    let apiTimeout: TimeInterval = 10.0
    let maxRetryAttempts: Int = 1
    
    // Feature flags
    let isFeatureXEnabled: Bool = false
    let isBetaFeaturesEnabled: Bool = false
}

struct EnvironmentConfig {
    // singleton
    static var shared = EnvironmentConfig()
    
    // current environment
    fileprivate(set) lazy var current: ConfigurationProtocol = {
#if DEV_ENVIRONMENT
        return DevConfiguration()
#elseif STAGING_ENVIRONMENT
        return StagingConfiguration()
#else
        return ProductionConfiguration()
#endif
    }()
    
    // override for testing
    mutating func setConfiguration(config: ConfigurationProtocol) {
        current = config
    }
    
    mutating func resetToDefault() {
#if DEV_ENVIRONMENT
        current = DevConfiguration()
#elseif STAGING_ENVIRONMENT
        current = StagingConfiguration()
#else
        current = ProductionConfiguration()
#endif
    }
    
    var baseUrl: String {
        let domain = Bundle.main.infoDictionary?["BASE_URL_STRING"] as? String ?? ""
        return "https://" + domain
    }
    
    var isMock: Bool {
#if DEV_ENVIRONMENT
        return true
#elseif STAGING_ENVIRONMENT
        return true // false
#else
        return true // false
#endif
    }
}
/*
 - Login    => Firebase login  with phone
 - Register => Firebase
 - Home screen:
 - Personal loan
 - Credit Card: Visa card, Master card
 - Installments: Car, Motorbike, Rickshow, General Installment, Agriculture
 - Digital Products: AEON Card, AEON Rohas, AEON Wallet
 - Left menu:
 - Notification
 - Lanuages
 - Term & Condition
 */
