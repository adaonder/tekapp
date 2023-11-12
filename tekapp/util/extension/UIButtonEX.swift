//
//  UIImageViewEX.swift
//  tekapp
//
//  Created by Önder Ada on 28.10.2023.
//

import Foundation
import UIKit

///Written for quick customization of Button
extension UIButton {
    
    //MARK: Color
    func setImageTintColor(_ color: UIColor) {
        let tintedImage = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(tintedImage, for: .normal)
        self.tintColor = color
    }
}
