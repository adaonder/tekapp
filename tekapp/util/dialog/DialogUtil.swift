//
//  DialogUtil.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import Foundation



public class DialogUtil {
    public static var shared = DialogUtil()
    
    //MARK: Progress
    func showLoading() {
        DispatchQueue.main.async {
            LoadingDialog.show("Lütfen bekleyiniz...", disableUI: true)
        }
    }
    
    func hideLoading() {
        DispatchQueue.main.async {
            LoadingDialog.hide()
        }
    }
}
