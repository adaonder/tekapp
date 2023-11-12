//
//  UIViewControllerEX.swift
//  tekapp
//
//  Created by Önder Ada on 26.10.2023.
//

import Foundation
import UIKit

//Genel amaçlı ViewController için gerekli functionslar yazıldı.
extension UIViewController {
    
    //MARK: Keyboard
    //For turn off the keyboard
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
