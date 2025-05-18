//
//  SplashVC.swift
//  Reminder
//
//  Created by Sami Gündoğan on 14.05.2025.
//

import SnapKit
import UIKit

class SplashViewController: UIViewController {
    
    private let viewModel : SplashVM = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        let imageView = UIImageView(image: UIImage(named: "splashreminder"))
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(imageView.snp.width)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.transitionToMainScreen()
        }
    }
    
    private func transitionToMainScreen() {
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = scene.windows.first(where: { $0.isKeyWindow }) else {
            return
        }

        let homeVC = HomeVC()
        let navigationController = UINavigationController(rootViewController: homeVC)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

