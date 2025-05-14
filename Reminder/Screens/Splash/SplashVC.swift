//
//  SplashVC.swift
//  Reminder
//
//  Created by Sami Gündoğan on 14.05.2025.
//

import SnapKit
import UIKit

class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let imageView = UIImageView(image: UIImage(named: "splashreminder"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(200)
        }
        let label = UILabel()
        label.text = "REMINDER"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = UIColor { traitCollection in
            return traitCollection.userInterfaceStyle == .dark ? .white : .black
        }
        
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(20)
            make.centerX.equalToSuperview()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.transitionToMainScreen()
        }
    }
    
    private func transitionToMainScreen() {
        let homeVC = HomeVC()
        let navigationController = UINavigationController(rootViewController: homeVC)
        
        if let window = UIApplication.shared.windows.first {
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        }
    }
}

