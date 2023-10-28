//
//  UIImageViewEX.swift
//  tekapp
//
//  Created by Önder Ada on 28.10.2023.
//

import Foundation
import UIKit


extension UIImageView {
    
    func setImageColor(color: UIColor) {
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color
    }
}
