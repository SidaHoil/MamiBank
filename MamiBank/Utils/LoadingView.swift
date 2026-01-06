//
//  LoadingView.swift
//  MamiBank
//
//  Created by Hoil Sida on 14/11/25.
//
import UIKit
import SwiftHelperInit

final class LoadingView: UIView {
    private let indicator = UIActivityIndicatorView(style: .large)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        backgroundColor = .black.withAlphaComponent(0.4)
        addSubview(indicator)
        indicator.centerInSuperview()
    }
    
    func show(on view: UIView) {
        frame = view.bounds
        view.addSubview(self)
        indicator.startAnimating()
    }
    
    func hide() {
        indicator.stopAnimating()
        removeFromSuperview()
    }
}
