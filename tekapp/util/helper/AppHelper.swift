//
//  AppHelper.swift
//  tekapp
//
//  Created by Önder Ada on 10.11.2023.
//

import UIKit

///AppDelegate ile SceneDelegate arasında ortak functionlar için yazıldı.
final class AppHelper {
    static func setWindowRootViewController(_ window: UIWindow?) {
        let currentNavigationController = UINavigationController(rootViewController: MainViewController())
        currentNavigationController.navigationBar.barTintColor = .black
        currentNavigationController.navigationBar.tintColor = .white
        window?.rootViewController = currentNavigationController
    }
}
