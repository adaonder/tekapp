//
//  UIScreenEX.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import UIKit

//UIScreen: Ekran boyutlarına daha hızlı ulaşmak için yazıldı.
extension UIScreen {
    static var screenHeight: CGFloat {
        get {
            let screenSize: CGRect = UIScreen.main.bounds
            return screenSize.height
        }
    }
    
    static var screenWidth: CGFloat {
        get {
            let screenSize: CGRect = UIScreen.main.bounds
            return screenSize.width
        }
    }
}
