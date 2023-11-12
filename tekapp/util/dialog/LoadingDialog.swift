//
//  LoadingDialog.swift
//  tekapp
//
//  Created by Önder Ada on 25.10.2023.
//

import Foundation
import UIKit

struct LoadingDialog {
    
    public struct Settings {
        public static var BackgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0)
        public static var ActivityColor = UIColor(red: 255/255, green: 0/255, blue: 0/255, alpha: 1.0)
        public static var TextColor = UIColor(red: 10/255, green: 10/255, blue: 10/255, alpha: 1.0)
        public static var FontName = "Quicksand-Regular"
        public static var SuccessIcon = "✔︎"
        public static var FailIcon = "✘"
        public static var SuccessText = "Success"
        public static var FailText = "Failure"
        public static var SuccessColor = UIColor(red: 68/255, green: 118/255, blue: 4/255, alpha: 1.0)
        public static var FailColor = UIColor(red: 255/255, green: 75/255, blue: 56/255, alpha: 1.0)
        public static var ActivityWidth = UIScreen.screenWidth / Settings.WidthDivision
        public static var ActivityHeight : CGFloat = 80
        public static var ShadowEnabled = true
        public static var WidthDivision: CGFloat {
            get {
                if UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad {
                    return  2.5
                } else {
                    return 1.4
                }
            }
        }
        public static var LoadOverApplicationWindow = true
        public static var backgroundEnable = true
    }
    
    fileprivate static var instance: LoadingActivity?
    fileprivate static var hidingInProgress = false
    fileprivate static var overlay: UIView!
    
    
    @discardableResult
    public static func show(_ text: String, disableUI: Bool) -> Bool {
        guard instance == nil else {
            return false
        }
        
        guard topMostController != nil else {
            return false
        }
        
        instance = LoadingActivity(text: text, disableUI: disableUI)
        DispatchQueue.main.async {
            if Settings.backgroundEnable {
                if overlay == nil {
                    overlay = UIView(frame: UIApplication.shared.keyWindow!.frame)
                }
                overlay.backgroundColor = UIColor.black.withAlphaComponent(0.2)
                overlay.frame = CGRect(x: 0, y: 0, width: UIScreen.screenWidth, height: UIScreen.screenHeight)
                topMostController?.view.addSubview(overlay)
                UIView.animate(withDuration: 0.2, animations: {overlay.backgroundColor = overlay.backgroundColor?.withAlphaComponent(0.5)})
            }
            instance?.showLoadingActivity()
        }
        return true
    }
    @discardableResult
    public static func showWithDelay(_ text: String, disableUI: Bool, seconds: Double) -> Bool {
        let showValue = show(text, disableUI: disableUI)
        delay(seconds) { () -> () in
            _ = hide(true, animated: false)
        }
        return showValue
    }
    
    public static func showOnController(_ text: String, disableUI: Bool, controller:UIViewController) -> Bool{
        guard instance == nil else {
            return false
        }
        instance = LoadingActivity(text: text, disableUI: disableUI)
        DispatchQueue.main.async {
            instance?.showLoadingWithController(controller)
        }
        
        return true
    }
    
    /// Returns success status
    @discardableResult
    public static func hide(_ success: Bool? = nil, animated: Bool = false) -> Bool {

        
        if overlay != nil {
            overlay.removeFromSuperview()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
        
        guard instance != nil else {
            return false
        }
        
        guard hidingInProgress == false else {
            return false
        }
        
        if !Thread.current.isMainThread {
            DispatchQueue.main.async {
                instance?.hideLoadingActivity(success, animated: animated)
            }
        } else {
            instance?.hideLoadingActivity(success, animated: animated)
        }
        
        return true
    }
    
    fileprivate static func delay(_ seconds: Double, after: @escaping ()->()) {
        let queue = DispatchQueue.main
        let time = DispatchTime.now() + Double(Int64(seconds * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)
        queue.asyncAfter(deadline: time, execute: after)
    }
    
    fileprivate class LoadingActivity: UIView {
        var textLabel: UILabel!
        var activityView = UIActivityIndicatorView()
        var icon: UILabel!
        var UIDisabled = false
        
        convenience init(text: String, disableUI: Bool) {
            self.init(frame: CGRect(x: 0, y: 0, width: Settings.ActivityWidth, height: Settings.ActivityHeight))
            
            var presentedVC = UIApplication.shared.keyWindow?.rootViewController
            while let pVC = presentedVC?.presentedViewController {
                presentedVC = pVC
            }
            center = CGPoint(x: presentedVC!.view.bounds.midX, y: presentedVC!.view.bounds.midY)
            autoresizingMask = [.flexibleTopMargin, .flexibleLeftMargin, .flexibleBottomMargin, .flexibleRightMargin]
            backgroundColor = Settings.BackgroundColor
            alpha = 1
            layer.cornerRadius = 8
            if Settings.ShadowEnabled {
                createShadow()
            }
            
            let yPosition = frame.height/2 - 20
            
           activityView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.whiteLarge)
           activityView.frame = CGRect(x: 20, y: yPosition, width: 40, height: 40)
           activityView.color = Settings.ActivityColor
           activityView.startAnimating()
            
            textLabel = UILabel(frame: CGRect(x: 60 + 20, y: yPosition, width: Settings.ActivityWidth - 70, height: 40))
            textLabel.textColor = Settings.TextColor
            textLabel.font = UIFont(name: Settings.FontName, size: 15)
            textLabel.adjustsFontSizeToFitWidth = true
            textLabel.minimumScaleFactor = 0.25
            textLabel.textAlignment = NSTextAlignment.left
            textLabel.text = text
            
            if disableUI {
                UIApplication.shared.beginIgnoringInteractionEvents()
                UIDisabled = true
            }
        }
        
        func showLoadingActivity() {
            addSubview(activityView)
            addSubview(textLabel)
            self.alpha = 0
            self.activityView.startAnimating()
            
            if Settings.LoadOverApplicationWindow {
                UIApplication.shared.windows.first?.addSubview(self)
            } else {
                var presentedVC = UIApplication.shared.keyWindow?.rootViewController
                while let pVC = presentedVC?.presentedViewController {
                    presentedVC = pVC
                }
                presentedVC!.view.addSubview(self)
            }
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            })
        }
        
        func showLoadingWithController(_ controller:UIViewController){
            addSubview(activityView)
            addSubview(textLabel)
            self.alpha = 0
            controller.view.addSubview(self)
            UIView.animate(withDuration: 0.2, animations: {
                self.alpha = 1
            })
        }
        
        func createShadow() {
            layer.shadowPath = createShadowPath().cgPath
            layer.masksToBounds = false
            layer.shadowColor = UIColor.black.cgColor
            layer.shadowOffset = CGSize(width: 0, height: 0)
            layer.shadowRadius = 4
            layer.shadowOpacity = 0.3
        }
        
        func createShadowPath() -> UIBezierPath {
            let myBezier = UIBezierPath()
            myBezier.move(to: CGPoint(x: -3, y: -3))
            myBezier.addLine(to: CGPoint(x: frame.width + 3, y: -3))
            myBezier.addLine(to: CGPoint(x: frame.width + 3, y: frame.height + 3))
            myBezier.addLine(to: CGPoint(x: -3, y: frame.height + 3))
            myBezier.close()
            return myBezier
        }
        
        func hideLoadingActivity(_ success: Bool?, animated: Bool) {
            hidingInProgress = true
            if UIDisabled {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
            
            var animationDuration: Double = 0
            if success != nil {
                if success! {
                    animationDuration = 0.5
                } else {
                    animationDuration = 1
                }
            }
            
            icon = UILabel(frame: CGRect(x: 10, y: frame.height/2 - 20, width: 40, height: 40))
            icon.font = UIFont(name: Settings.FontName, size: 60)
            icon.textAlignment = NSTextAlignment.center
            
            if animated {
                textLabel.fadeTransition(animationDuration)
            }
            
            if success != nil {
                if success! {
                    icon.textColor = Settings.SuccessColor
                    icon.text = Settings.SuccessIcon
                    textLabel.text = Settings.SuccessText
                } else {
                    icon.textColor = Settings.FailColor
                    icon.text = Settings.FailIcon
                    textLabel.text = Settings.FailText
                }
            }
            
            addSubview(icon)
            
            if animated {
                icon.alpha = 0
                activityView.stopAnimating()
                UIView.animate(withDuration: animationDuration, animations: {
                    self.icon.alpha = 1
                }, completion: { (value: Bool) in
                    UIView.animate(withDuration: 0.2, animations: {
                        self.alpha = 0
                    }, completion: { (success) in
                        self.callSelectorAsync(#selector(UIView.removeFromSuperview), delay: animationDuration)
                    })
                    instance = nil
                    hidingInProgress = false
                })
            } else {
                activityView.startAnimating()
                self.callSelectorAsync(#selector(UIView.removeFromSuperview), delay: animationDuration)
                instance = nil
                hidingInProgress = false
            }
        }
    }
}

private extension UIView {
    func fadeTransition(_ duration: CFTimeInterval) {
        let animation: CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        animation.type = CATransitionType.fade
        animation.duration = duration
        self.layer.add(animation, forKey: CATransitionType.fade.rawValue)
    }
}

private extension NSObject {
    func callSelectorAsync(_ selector: Selector, delay: TimeInterval) {
        let timer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: selector, userInfo: nil, repeats: false)
        RunLoop.main.add(timer, forMode: .common)
    }
}

private var topMostController: UIViewController? {
    var presentedVC = UIApplication.shared.keyWindow?.rootViewController
    while let pVC = presentedVC?.presentedViewController {
        presentedVC = pVC
    }
    
    return presentedVC
}
