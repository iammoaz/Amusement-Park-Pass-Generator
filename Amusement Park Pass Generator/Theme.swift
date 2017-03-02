//
//  Theme.swift
//  Amusement Park Pass Generator
//
//  Created by Muhammad Moaz on 2/17/17.
//  Copyright © 2017 Muhammad Moaz. All rights reserved.
//

import UIKit

struct Theme {
    
    static var primaryColor: UIColor {
        return UIColor(red: 0.54, green: 0.43, blue: 0.65, alpha: 1.00)
    }
    
    static var accentColor: UIColor {
        return UIColor(red: 0.34, green: 0.58, blue: 0.56, alpha: 1.00)
    }
    
    static var buttonBorderColor: UIColor {
        return UIColor(red: 0.34, green: 0.58, blue: 0.56, alpha: 1.00)
    }
    
    static var fadeButtonColor: UIColor {
        return UIColor(red: 0.84, green: 0.73, blue: 0.95, alpha: 0.90)
    }
    
    static var disableColor: UIColor {
        return UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.00)
    }
    
    static var textFieldBackgroundColor: UIColor {
        return UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.00)
    }
    
    static var accessGrantedColor: UIColor {
        return UIColor(red: 0.00, green: 0.58, blue: 0.31, alpha: 1.00)
    }
    
    static var accessDeniedColor: UIColor {
        return UIColor(red: 0.93, green: 0.09, blue: 0.18, alpha: 1.00)
    }
    
    static var subTypeButtonColor: UIColor {
        return UIColor(red: 0.84, green: 0.73, blue: 0.95, alpha: 1.00)
    }
    
    static func mediumFont(size: CGFloat) -> UIFont {
        return UIFont(name: "Avenir-Heavy", size: size)!
    }
    
    static func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(subTypeButtonColor, for: .normal)
        button.titleLabel?.font = mediumFont(size: 15.0)
        return button
    }
    
    static func displayAlert(title: String, message: String, viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        alertController.view.tintColor = Theme.accentColor
        viewController.present(alertController, animated: true, completion: {
            alertController.view.tintColor = Theme.accentColor
        })
    }
}
