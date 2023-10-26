//
//  UIScreenEX.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import UIKit

extension UIScreen {
    
    static var DEVICE_TOP_PADDING : CGFloat = 44.0 * 2.56
    static var DEVICE_BOTTOM_PADDING : CGFloat = 34.0 * 2.56
    
    class var Orientation: UIInterfaceOrientation {
        get {
            return UIApplication.shared.statusBarOrientation
        }
    }
    
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
    
    static var getScreenHeightWitoutSpaces: CGFloat {
        get {
            let screenSize: CGRect = UIScreen.main.bounds
            return screenSize.height - (DEVICE_TOP_PADDING + DEVICE_BOTTOM_PADDING)
        }
    }
}
