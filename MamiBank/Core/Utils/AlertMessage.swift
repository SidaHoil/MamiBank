//
//  AlertMessage.swift
//  MamiBank
//
//  Created by Hoil Sida on 24/10/25.
//
import UIKit

class AlertMessage: UIViewController {
    static let shared = AlertMessage()
    
    func show(title: String, message: String, action: @escaping () -> Void = {})  {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "ok".translate, style: .default,handler: { _ in
            action()
        }))
        
        DispatchQueue.main.async {
            if let presenter = self.topMostViewController() {
                presenter.present(alert, animated: true)
            } else {
                self.present(alert, animated: true)
            }
        }
    }
    
    private func topMostViewController(from root: UIViewController? = UIApplication.shared.connectedScenes
        .compactMap { ($0 as? UIWindowScene)?.keyWindow }
        .first?.rootViewController) -> UIViewController? {
        if let nav = root as? UINavigationController {
            return topMostViewController(from: nav.visibleViewController)
        } else if let tab = root as? UITabBarController {
            return topMostViewController(from: tab.selectedViewController)
        } else if let presented = root?.presentedViewController {
            return topMostViewController(from: presented)
        } else {
            return root
        }
    }
}

