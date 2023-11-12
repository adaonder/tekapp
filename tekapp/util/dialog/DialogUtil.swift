//
//  DialogUtil.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import UIKit

//Dialogları tek yerden kontrol amaçlı yazıldı.
final class DialogUtil {
    public static var shared = DialogUtil()
    
    //MARK: Progress
    func showLoading() {
        DispatchQueue.main.async {
            LoadingDialog.show("wait_while_loading".localized(), disableUI: true)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            LoadingDialog.hide()
        }
    }
    
    //MARK: Message Dialog
    func showMessage(_ view: UIViewController,_ title: String, _ message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ok".localized(), style: .default, handler: nil))
        view.present(alert, animated: true, completion: nil)
    }
}
